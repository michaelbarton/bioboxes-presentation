$(shell rm -f tmp/imagemagick/*)
$(shell mkdir -p tmp/png tmp/imagemagick out)

name   = builder
docker = docker \
	   run \
	   --volume=$(shell pwd):/mnt:rw \
	   --env=MAGICK_TEMPORARY_PATH=/mnt/tmp/imagemagick \
	   --rm \
	   $(name)

PERCENT    := %
dimensions := "1000x750"
papersize  := '{1000px,750px}'
n_slides   := 120

build: $(patsubst data/%.txt,out/%.pdf,$(shell find data -name '*.txt'))


out/%.pdf: data/%.txt tmp/slides.pdf
	pdfjam \
		$(shell pwd)/$(lastword $^) \
		$(shell cut -f 1 $< | paste -sd "," -) \
		--papersize  $(papersize) \
		--outfile $@

tmp/slides.pdf: tmp/png/.complete
	$(docker) convert \
		-page $(dimensions) \
		/mnt/$(dir $<)*.png \
		-format pdf \
		/mnt/$@

tmp/png/.complete: tmp/image.png
	$(docker) convert \
		-crop "1x$(n_slides)@" \
		-resize $(dimensions) \
		/mnt/$< \
		/mnt/$(dir $@)$(PERCENT)03d.png
	touch $@

tmp/image.png: src/slides.svg
	$(docker) inkscape \
		--file=/mnt/$< \
		--export-png=/mnt/$@ \
		--export-dpi=100 \
		--export-area-page

########################################
#
# Bootstrap the project resources
#
########################################

bootstrap: .image

.image: Dockerfile
	docker build -t $(name) .
	touch $@

clean:
	rm -rf tmp/* out/* .image
