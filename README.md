# dum_speed_test
Bash/gnuplot scripts for measuer  speed you bandwitch 
```bash
  git clone https://github.com/dzaczek/dum_speed_test.git
  
  cd dum_speed_test
  docker build . -t dum_speed_test_c:0.19
 
 
  docker run -p80:80 -d  dum_speed_test_c:0.19
```
