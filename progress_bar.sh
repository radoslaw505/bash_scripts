
count=0
start=`date +%s`
list="C1 C2 C3 C4 C5 C6 C7 C8 C9 C10"
processes=3

v_processes=0

for i in $list; do
  if [ $v_processes -ge $processes ]; then

    while [ $count -lt $total ]; do
      sleep 0.01 # this is work
      cur=`date +%s`
      count=$(( $count + 1 ))
      pd=$(( $count * 73 / $total ))
      runtime=$(( $cur-$start ))
      estremain=$(( ($runtime * $total / $count)-$runtime ))
      printf "\r%d.%d%% complete ($count of $total) - est %d:%0.2d remaining\e[K" $(( $count*100/$total )) $(( ($count*1000/$total)%10)) $(( $estremain/60 )) $(( $estremain%60 ))
    done
    printf "\ndone\n"

  else
    ((v_processes++))
    n_total=$((total + 1000))
    total=$n_total
    echo "$i executed"
  fi
done
