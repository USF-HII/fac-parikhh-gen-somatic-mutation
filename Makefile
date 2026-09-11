all:
	rsync -rvt --exclude='.nfs*' --exclude=.git --exclude=.jj --exclude=tmp . hii2.rc.usf.edu:/quobyte/hii/shares/hii-teddy/work/kcounts/gen-somatic-mutation
