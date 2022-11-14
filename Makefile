lint: ansible

ansible:
	yamllint -c .config/yamllint .
	ansible-lint
