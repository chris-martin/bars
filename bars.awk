
 BEGIN {

#Command-line options

   FS=",";       #column seperator
   Round=10;     #size of bins
   Collect=2;    #column to process
   Mark="*";     #marks to draw histogram
   NoSort=0;     #disable sorting of keys
   Col1=4;       #width of histogram key column
   Col2=3;       #width of histogram key value column
   Col3=20;      #width of histogram bar display column

#Internal globals

   Num;          #array where we store the numbers
   Inf= 2**32;   #the largest number we can process
   Max = -1*Inf; #max count seen in any bucket
                 #initialized to the smallest number
   Here;         #the key of the current bucket
 }

#Convert the symbol "NF" to the number of the last field

 NR==1 {if (Collect=="NF") Collect=NF;}

#Collect the number, rounded.

 { if (Round) {
     Here=round($Collect/Round)*Round}
   else {Here=$Collect};
   Num[Here]++;
   if (Num[Here]>Max) Max=Num[Here];
 }

#Report

 END {
   if (NoSort) {
     histogram(Num) }
   else {
     sortedgram(Num)}
 }

#Generate histogram bars for the entire histogram

  function histogram(a, i) { for(i in a) print bar(a,i) } 

#Pre-sort the histogram and generated the bars in
#sorted order

 function sortedgram(a, add,i,j,keys,n) {
   for(i in a) {
     if (Round) { 
       keys[j++]=i+0}   #ensures numeric, not string, sort
     else keys[j++]=i}   
   n=asort(keys);
   for(i=1;i<=n;i++) 
     print bar(a,keys[i]);
 }

#Genrate a single histogram bar of Marks, resized according to 
#the column3 width.

 function bar(a,i,     scale) {
   if (Max < Col3) { 
     scale=1 }
   else {scale=Col3/Max};
   if (Round) {
     return  sprintf(" %" Col1".0f|%" Col2 "d| %s",\
         i, a[i],string(round(a[i]*scale),Mark))}
   else {
      return  sprintf(" %"Col1" s|%"Col2" d| %s",\
         i, a[i],string(round(a[i]*scale),Mark))}
 }

#Round a number

 function round(x) { return int(x+0.5) } 

#Generate a string n long of characters c.

 function string(n,c,  s) { while(n--) {s=s c}; return s}
