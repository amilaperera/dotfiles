SKILLS_DIR := $(CURDIR)/skills
TARGET_DIR := $(HOME)/.copilot/skills
SKILLS := $(notdir $(wildcard $(SKILLS_DIR)/*))
DRY ?= 0

.PHONY: copilot clean copilot-dry clean-dry

copilot:
	@mkdir -p "$(TARGET_DIR)"
	@echo "Linking skills from $(SKILLS_DIR) to $(TARGET_DIR)"
	@for s in $(SKILLS); do \
		src="$(SKILLS_DIR)/$$s"; dest="$(TARGET_DIR)/$$s"; \
		if [ "$(DRY)" = "1" ]; then \
			echo "Would link $$dest -> $$src"; \
		else \
			ln -sf "$$src" "$$dest"; echo "linked $$dest -> $$src"; \
		fi; \
	done

copilot-dry: DRY=1
copilot-dry: copilot

clean:
	@echo "Removing symlinked skills in $(TARGET_DIR)"
	@for s in $(SKILLS); do \
		dest="$(TARGET_DIR)/$$s"; \
		if [ -L "$$dest" ]; then \
			if [ "$(DRY)" = "1" ]; then \
				echo "Would remove $$dest"; \
			else \
				rm -f "$$dest"; echo "removed $$dest"; \
			fi; \
		else \
			echo "skipping $$dest (not a symlink)"; \
		fi; \
	done

clean-dry: DRY=1
clean-dry: clean
