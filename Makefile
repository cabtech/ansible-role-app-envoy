lint: .ylint .alint

.alint: */*.yml .config/ansible-lint.yml
	ansible-lint --config-file=.config/ansible-lint.yml
	@touch $@

.ylint: */*.yml .config/yamllint
	yamllint --config-file=.config/yamllint .
	@touch $@

# --------------------------------

push:
	@mkdir -p /mnt/hgfs/shared/ansible-role-app-envoy
	rsync -a * /mnt/hgfs/shared/ansible-role-app-envoy

clean:
	@/bin/rm -f .alint .ylint

