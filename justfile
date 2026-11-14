
ASSETS_DIR := './assets'
BUILD_DIR := './target'
SOURCE_DIR := './'

# The volumes of the songbook, in order of volume number: the top level typ files, each one compiled to a PDF with the
# same name. Just has no arrays, so this is the text of a bash array (one quoted entry per line, the names have spaces).
VOLUMES := '''
  "Le storie di Mowgli (a4_2columns).typ"
  "Le storie di Mowgli (a4).typ"
  "Le storie di Mowgli (a5).typ"
'''

# Lists all the available commands
default:
  @just --list


# Compiles all the volumes, with the PDF bookmarks expanded
[group('compile')]
compile: clean
  #!/usr/bin/env bash
  set -euo pipefail
  volumes=({{VOLUMES}})
  mkdir -p {{BUILD_DIR}}
  for file in "${volumes[@]}"; do
    file="{{SOURCE_DIR}}/$file"
    pdf="{{BUILD_DIR}}/${file%.typ}.pdf"
    echo "Compiling $file"
    typst compile "$file" "$pdf"
    just bookmarks_workaround "$pdf"
  done

# Cleans the build directory
[group('compile')]
clean:
  rm -rf {{BUILD_DIR}}


# Workaround for https://github.com/typst/typst/issues/8872
#
# Typst exports the PDF bookmarks collapsed, so every section has to be opened by hand to see the
# song titles. Until that is fixed, qpdf and jq flip
# them open (sudo apt install qpdf jq).
[private]
bookmarks_workaround filename:
  #!/usr/bin/env bash
  set -euo pipefail
  trap 'rm -f {{BUILD_DIR}}/bookmarks_expanded.json' EXIT

  qpdf --json=2 --json-key=qpdf "{{filename}}" | jq '
    .qpdf[1] as $objs
    | [ $objs | to_entries[]
        | select(.value.value | type == "object" and has("/Title") and has("/Parent"))
        | {id: .key, parent: ("obj:" + .value.value["/Parent"])} ] as $items
    | ($items | map({(.id): .parent}) | add // {}) as $parent
    | def ancestors($id): if $parent[$id] then [$parent[$id]] + ancestors($parent[$id]) else [] end;
      ([ $items[] | ancestors(.id)[] ] | group_by(.) | map({(.[0]): length}) | add // {}) as $descendants
    | { qpdf: [ {jsonversion: 2},
                ( $descendants | to_entries
                  | map(.key as $k | {key: $k, value: ($objs[$k] | .value["/Count"] = $descendants[$k])})
                  | from_entries ) ] }
  ' > {{BUILD_DIR}}/bookmarks_expanded.json
  qpdf "{{filename}}" --update-from-json={{BUILD_DIR}}/bookmarks_expanded.json \
    --stream-data=preserve --object-streams=preserve --replace-input