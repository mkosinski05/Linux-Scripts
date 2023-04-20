ADDRMAPS=(`find . -name "*addrmap_intm.yaml"`)

sorted_array=($(echo "${ADDRMAPS[*]}" | tr ' ' '\n' | sort))
	
for i in "${sorted_array[@]}"
do
   python parser_addrmap.py $i
done


