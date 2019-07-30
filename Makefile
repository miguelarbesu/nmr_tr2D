DATA_DIR = ./data

explist: get_explist.sh
	for dir in $(DATA_DIR)/*; do ./get_explist.sh $$dir/; done
