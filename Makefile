SHELL = /bin/sh

.DEFAULT_GOAL := dist

###
### Параметры ..................................................................

# Директория с оригинальной прошивкой для 7oL
ORIG_DIR := ../orig
export ORIG_DIR

# Директория куда будет сохранен результат
OUT_DIR := ../__init_imapx820
export OUT_DIR

# Использовать gzip для сжатия
# (сжимать-ли вообще) system.img.
# 0 - Не сжимать (gzip не будет запущен)
# 1..9 - Сжимать. 1 - макс. скорость; 9 - макс. сжатие.
USE_GZIP_FOR_SYSTEM_IMG := 0
export USE_GZIP_FOR_SYSTEM_IMG




$(OUT_DIR) :
	mkdir -p "$(@)"
	chmod 777 "$(@)"

$(OUT_DIR)/items.itm : items.itm
	cp -f "$(<)" "$(@)"
	chmod 666 "$(@)"



.DELETE_ON_ERROR : $(OUT_DIR)/logo.isi
$(OUT_DIR)/logo.isi : logo/battery0.bmp \
                      logo/battery1.bmp \
                      logo/battery2.bmp \
                      logo/battery3.bmp \
                      logo/batteryfull.bmp \
                      logo/batterylow.bmp \
                      logo/bootup.bmp \
                      logo/poweron.bmp
	cp -f "$(ORIG_DIR)/logo.isi" "$(@)"
	./makelogo push "$(@)"
	chmod 666 "$(@)"



$(OUT_DIR)/ramdisk.img : $(ORIG_DIR)/ramdisk.img
	cp -f "$(<)" "$(@)"
	chmod 666 "$(@)"

$(OUT_DIR)/recovery-rd.img : $(ORIG_DIR)/recovery-rd.img
	cp -f "$(<)" "$(@)"
	chmod 666 "$(@)"

system.add : makehosts hosts/hosts \
             makebootanim bootanim/bootanimation.zip \
             ../apps/pckeyboard.apk \
             ../apps/com.estrongs.android.pop.apk
	touch "$(@)"

.DELETE_ON_ERROR : $(OUT_DIR)/system.img
$(OUT_DIR)/system.img : $(ORIG_DIR)/system.img \
                        system.rm \
                        system.add \
                        system.ln \
                        build.prop \
                        default.prop \
                        repack.s.img
#-----------------------------------------------------------
	@export TARGET_FILE="$(@)" ; \
	export ORIG_FILE="$(<)"    ; \
	./repack.s.img $(^)
	chmod 666 "$(@)"



$(OUT_DIR)/u01.isi : $(ORIG_DIR)/u01.isi
	cp -f "$(<)" "$(@)"
	chmod 666 "$(@)"

$(OUT_DIR)/uboot0.isi : $(ORIG_DIR)/uboot0.isi
	cp -f "$(<)" "$(@)"
	chmod 666 "$(@)"

$(OUT_DIR)/uboot1.isi : $(ORIG_DIR)/uboot1.isi
	cp -f "$(<)" "$(@)"
	chmod 666 "$(@)"

$(OUT_DIR)/uImage : $(ORIG_DIR)/uImage
	cp -f "$(<)" "$(@)"
	chmod 666 "$(@)"

$(OUT_DIR)/README : README
	cp -f "$(<)" "$(@)"
	chmod 666 "$(@)"



.PHONY : dist
dist : $(OUT_DIR) \
       $(OUT_DIR)/README \
       $(OUT_DIR)/items.itm \
       $(OUT_DIR)/logo.isi \
       $(OUT_DIR)/ramdisk.img \
       $(OUT_DIR)/recovery-rd.img \
       $(OUT_DIR)/system.img \
       $(OUT_DIR)/u01.isi \
       $(OUT_DIR)/uboot0.isi \
       $(OUT_DIR)/uboot1.isi \
       $(OUT_DIR)/uImage



.PHONY : clean
clean :
	rm -rf "$(OUT_DIR)"


#.PHONY : mms
#mms : dist
#GOCLEVER
