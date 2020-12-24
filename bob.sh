for d in */; 
do 
#ignore terra dirs and hidden dirs/files
if [[ "$d" == *"terra"* ]] || [[ "$d" =~ ^\. ]]; then
   continue
fi

#logic
echo "Logic on $d"
done
