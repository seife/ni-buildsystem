################################################################################
#
# samba
#
################################################################################

samba: $(if $(filter $(BOXSERIES),hd1),samba33,samba36)
	$(TOUCH)