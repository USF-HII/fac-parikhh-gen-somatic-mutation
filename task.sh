#!/usr/bin/env bash

# ----------------------------------------------------------------------------------------------------
# util funcs
# ----------------------------------------------------------------------------------------------------

tmp() { # tmp() [path] - makes dir under ${TMP}/<task>[/path] and echoes path for capture
  local task=$(echo ${FUNCNAME[1]} | sed 's/^task_//')
  local dir="${TOP}/tmp/task/${task}"
  if [[ $# -eq 1 ]]; then dir=${dir}/$1; fi
  if ! [[ -d ${dir} ]]; then /bin/mkdir -p ${dir}; fi
  echo ${dir}
}

mosaichunter() {
  bio-img java8 -Xmx16g -jar ${MH_JAR} "$@"

  # bash task.sh run_mosaichunter help genome
  # MosaciHunter v1.0, a post-zygotic single nucleotide mosaicism calling tool
  # This mode is for genome data.
  #
  # Usage:
  #    java -jar mosaichunter.jar genome -P parameter=value -P ...
  #
  # Options:
  #    ...
  #    repetitive_region_filter.bed_file
  #       The .bed file of repetitive regions. Required.
  #    indel_region_filter.bed_file
  #       The .bed file of indel regions. Required.
  #    common_site_filter.bed_file
  #       The .bed file of commons sites. Required.
  #    ...
}

# ----------------------------------------------------------------------------------------------------
# tasks
# ----------------------------------------------------------------------------------------------------

task_mosaichunter() {
  local out=$(tmp)

  mosaichunter \
    genome \
    -P misaligned_reads_filter.blat_path=${MH_BLAT_PATH} \
    -P input_file=${MH_INPUT_FILE} \
    -P reference_file=${MH_REFERENCE_FILE} \
    -P mosaic_filter.dbsnp_file=${MH_DBSNP_FILE} \
    -P mosaic_filter.sex=M \
    -P output_dir=${out}

  /bin/find ${out} -type f | sort --version-sort
}


# ----------------------------------------------------------------------------------------------------
# global vars
# ----------------------------------------------------------------------------------------------------

TOP=$(readlink -f $(dirname "$0"))
TMP=${TOP}/tmp/task

MH_INPUT_DIR=${BIO}/lab/radiant/broad/Human-WGS-BAM-1/RADIANT_Set001-002_41samples/RADIANT_Set001-002_41samples_BAM
MH_INPUT_FILE=${MH_INPUT_DIR}/134542-0359493956_PM21-00438-A_SM-L5BY4_v1_WGS_GCP.bam
MH_REFERENCE_FILE=${BIO}/ref/broad/hg38/v0/Homo_sapiens_assembly38.fasta
MH_DBSNP_FILE=${BIO}/ref/broad/hg38/v0/Homo_sapiens_assembly38.dbsnp138.vcf.gz
MH_BLAT_PATH=${BIO}/ref/prj/somatic-mutation/mosaichunter/blat-v369
MH_JAR=${BIO}/ref/prj/somatic-mutation/mosaichunter/mosaichunter-4bdadaa7.jar

# ----------------------------------------------------------------------------------------------------
# main
# ----------------------------------------------------------------------------------------------------

if [[ $# -lt 1 ]]; then
  set | grep task_ | sed 's/task_//' | cut -d' ' -f1 | sort
  exit 1
else
  cmd=$1; shift
  task_${cmd} "$@"
fi

"$@"
