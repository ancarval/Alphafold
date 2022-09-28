#!/bin/bash
#
# Copyright 2021 DeepMind Technologies Limited
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Downloads and unzips the PDB70 database for AlphaFold.
#
# Usage: bash download_pdb70.sh /path/to/download/directory
set -e

if [[ $# -eq 0 ]]; then
    echo "Error: download directory must be provided as an input argument."
    exit 1
fi

if ! command -v aria2c &> /dev/null ; then
    echo "Error: aria2c could not be found. Please install aria2c (sudo apt install aria2)."
    exit 1
fi

DOWNLOAD_DIR="$1"
ROOT_DIR="${DOWNLOAD_DIR}/pdb70"

mkdir --parents "${ROOT_DIR}"
mkdir --parents "${ROOT_DIR}/downloading"

SOURCE_URL="http://wwwuser.gwdg.de/~compbiol/data/hhsuite/databases/hhsuite_dbs/pdb70_from_mmcif_220313.tar.gz"
BASENAME=$(basename "${SOURCE_URL}")

aria2c -x 10 "${SOURCE_URL}" --dir="${ROOT_DIR}/downloading/"

mkdir --parents "${ROOT_DIR}/old"
mv ${ROOT_DIR}/pdb* ${ROOT_DIR}/old/

tar --extract --verbose --file="${ROOT_DIR}/downloading/${BASENAME}" \
  --directory="${ROOT_DIR}"
rm "${ROOT_DIR}/downloading/${BASENAME}"