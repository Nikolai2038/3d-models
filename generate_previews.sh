#!/bin/sh

height=200
width=200

main() {
  if ! which openscad > /dev/null 2>&1; then
    echo "\"openscad\" is not installed!"
    return 1
  fi

  if ! [ -d "./models" ]; then
    echo "The \"models\" directory does not exist in \"${PWD}\"!"
    return 1
  fi

  for file_path in ./models/*.stl; do
    base_name="$(basename "${file_path}" .stl)" || return "$?"
    temp_file_path="/tmp/${base_name}.scad"
    # shellcheck disable=SC2320
    echo "import(\"$(realpath "${file_path}")\");" > "${temp_file_path}" || return "$?"
    openscad --colorscheme="Tomorrow Night" -o "./previews/${base_name}.png" --autocenter --viewall --imgsize="${width},${height}" "${temp_file_path}" || return "$?"
    rm "${temp_file_path}"
  done
}

main "$@" || exit "$?"
