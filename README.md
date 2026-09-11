# fac-parikhh-gen-somatic-mutation

## links

issues
- [usf-hii/adm/issue/329](https://github.com/USF-HII/fac-parikhh-admin/issues/329) - RAD and TDY WGS Somatic mutation analysis
- [AI suggestion](https://share.gemini.google/jAyid0T92TvC)

software
- MosaicHunter
  - [MosaicHunter Repo](https://github.com/zzhang526/MosaicHunter)
    A tool to detect postzygotic single-nucleotide mosaicism from unpaired, trio, or paired samples.
  - [MosaicHunter Repo conf/genome.properties](https://github.com/zzhang526/MosaicHunter/blob/master/conf/genome.properties)
  - [MosaicHunter Repo docs/MosaicHunterUserGuide.pdf](https://github.com/zzhang526/MosaicHunter/blob/master/docs/MosaicHunterUserGuide.pdf)
- [DeepMosaic](https://github.com/XiaoxuYangLab/DeepMosaic)

## log

## 2026-09-10 mosaichunter

We were able to add the following UCSC files from `/home/bioinfo/outbox/parikhh/for_kevin/teddy_ncc2_wgs` and copied them
under `tmp/data/` for testing.

After executing, mosaichunter picked up these files according to the log:
```
tmp/task/mosaichunter/stdout_20260911_012523.156.log:common_site_filter.bed_file = /home/countskm/dev/usf-hii/gen-somatic-mutation/tmp/data/ucsc_common_hg38.bed
tmp/task/mosaichunter/stdout_20260911_012523.156.log:indel_region_filter.bed_file = /home/countskm/dev/usf-hii/gen-somatic-mutation/tmp/data/ucsc_indel_hg38.bed
tmp/task/mosaichunter/stdout_20260911_012523.156.log:repetitive_region_filter.bed_file = /home/countskm/dev/usf-hii/gen-somatic-mutation/tmp/data/ucsc_repetitive_region_hg38.bed
```

However all `*.tsv` outputs are still showing 0 byte output.

We updated the log output to the newest run and it is available here:
- https://github.com/USF-HII/fac-parikhh-gen-somatic-mutation/blob/main/mosaichunter-log.txt


## 2026-09-03 mosaichunter

After much trial and error we have a "running" mosaichunter.

The run is defined here: https://github.com/USF-HII/fac-parikhh-gen-somatic-mutation/blob/main/task.sh#L40

The output log is here: https://github.com/USF-HII/fac-parikhh-gen-somatic-mutation/blob/main/mosaichunter-log.txt

It appears not to give any results as all `*.tsv` are zero-bytes but at least we have, for the first time, a running, base reference point.


## 2026-09-02 mosaichunter

I have been attempting to get the mosaichunter tool to work.

The [AI suggestion](https://share.gemini.google/jAyid0T92TvC) appears to be somewhat halucinated and some of the parameters suggested
were nonsense.

Its web site listed in the repo, http://mosaichunter.cbi.pku.edu.cn, no longer works.

Fortunately, there was a [MosaicHunterUserGuide](https://github.com/zzhang526/MosaicHunter/blob/master/docs/MosaicHunterUserGuide.pdf)
found in the repo so I had some reference point.

Per the user guide, I was able to

I did notice these parameters when running `mosaichunter` with the `genome` option which I have no idea what these input files would be:
- `repetitive_region_filter.bed_file (The .bed file of repetitive regions. Required.)`
- `indel_region_filter.bed_file      (The .bed file of indel regions. Required.)`
- `common_site_filter.bed_file       (The .bed file of commons sites. Required.)`

I downloaded 3 versions of blat from https://hgdownload.gi.ucsc.edu/admin/exe:
- tmp/blat/v479/blat
- tmp/blat/v385/blat
- tmp/blat/v369/blat

## 2026-09-01 mosaichunter

Grabbed latest copy of blat:
- <https://hgdownload.gi.ucsc.edu/admin/exe/linux.x86_64.v479/blat/blat>

---

It took some searching but I believe the file referrence in the mosaichunter example AI provided (`common_snp_vcf = /path/to/resources/dbsnp_138.hg38.vcf`) was found in the broad gcp public data at:
- https://storage.googleapis.com/gcp-public-data--broad-references/hg38/v0

I downloaded this and these other files and located then under `${BIO}/ref/broad/hg38/v0/`:
```
Homo_sapiens_assembly38.dbsnp138.vcf.gz
Homo_sapiens_assembly38.dbsnp138.vcf.gz.tbi
Homo_sapiens_assembly38.dict
Homo_sapiens_assembly38.fasta
Homo_sapiens_assembly38.fasta.amb
Homo_sapiens_assembly38.fasta.ann
Homo_sapiens_assembly38.fasta.bwt
Homo_sapiens_assembly38.fasta.fai
Homo_sapiens_assembly38.fasta.pac
Homo_sapiens_assembly38.fasta.sa
```

### 2026-08-31 mosaichunter

parikhh created a ticket sharing an [AI overview](https://share.gemini.google/jAyid0T92TvC) of a potential workflow for somatic mutation.

The first step uses a tool not previously mentioned, [MosaicHunter](https://github.com/zzhang526/MosaicHunter).

The repo was last updated 2021-02.

Its web site listed in the repo, http://mosaichunter.cbi.pku.edu.cn, no longer works.

I did not realize that a jar was included within the repository so I went through the whole process of installing an openjdk-8, installing the ant build tool, and compiling the jar from source.

After identifying the jar was included in the repo, I decided to use that version rather than my built one.

I have located it at: `${BIO}/ref/prj/somatic-mutation/mosaichunter.jar`
