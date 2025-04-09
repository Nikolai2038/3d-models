#!/bin/sh

height=200
width=200

main() {
  cd "$(dirname "$0")" || return "$?"

  if ! which openscad > /dev/null 2>&1; then
    echo "\"openscad\" is not installed!"
    return 1
  fi

  if ! [ -d "./.readme_images" ]; then
    echo "The \".readme_images\" directory does not exist in \"${PWD}\"!"
    return 1
  fi

  if ! [ -d "./stl" ]; then
    echo "The \"stl\" directory does not exist in \"${PWD}\"!"
    return 1
  fi

  for file_path in ./stl/*.stl; do
    base_name="$(basename "${file_path}" .stl)" || return "$?"
    temp_file_path="/tmp/${base_name}.scad"
    # shellcheck disable=SC2320
    echo "import(\"$(realpath "${file_path}")\");" > "${temp_file_path}" || return "$?"
    openscad --colorscheme="Tomorrow Night" -o "./.readme_images/${base_name}.png" --autocenter --viewall --imgsize="${width},${height}" "${temp_file_path}" || return "$?"
    rm "${temp_file_path}"
  done
}

main "$@" || exit "$?"
