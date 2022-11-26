# MATLAB/Octave Implementation of WINNER II Propagation Model

This code repository contains a MATLAB/Octave software implementation of [WINNER II](http://www.ero.dk/93F2FC5C-0C4B-4E44-8931-00A5B05A331B) path loss prediction method (Table 4-4).  Note that only outdoor scenarios C1 (Suburban macro-cell), C2 (Urban macro-cell), and D1 (Rural macro-cell) are implemented in this version. The model supports LoS and NLoS propagation conditions as well as the LoS probabilities. 


The following table describes the structure of the folder `./matlab/` containing the MATLAB/Octave implementation of the WINNER II model.

| File/Folder               | Description                                                         |
|----------------------------|---------------------------------------------------------------------|
|`tl_winner2.m`                | MATLAB/Octave implementation of WINNER II propagation model         |
|`winner2_RMa.m`          | Outdoor D1 scenario         |
|`winner2_SMa.m`          | Outdoor C1 scenario         |
|`winner2_UMa.m`          | Outdoor C2 scenario         |


Function call
~~~ 
L = tl_winner2(f, d, h1, h2, env, lostype, variations);
~~~

## Required input arguments of function `tl_winner2`

| Variable          | Type   | Units | Limits       | Description  |
|-------------------|--------|-------|--------------|--------------|
| `f`               | double | GHz   | 2 ≤ `f`≤ 6   | Frequency | 
| `d`               | double | m   | See Note   | 3D direct distance between Tx and Rx stations  |
| `h1`               | double | m   |  See Note  | Antenna height of the first terminal |
| `h2`               | double | m   |   See Note | Antenna height of the second terminal |
| `env`      | string |    | 'RURAL', 'SUBURBAN', 'URBAN' | Environment type |
| `lostype`      | int |     |  | 1 - LoS <br> 2 - NLoS <br> 3 - LoS Probability |
| `variations`      | boolean |     |  | Set to `true` to compute variation in path loss (shadow fading)|



### Note 
Maximum distance: 5 km (10 km for D1 LoS).
<br> Minimum distance:  10 m (30 m for C1) for LoS  and 50 m for NLoS.
<br> Antenna heights must be positive (not smaller than 1 m for C2 LoS)


## Output ##

| Variable   | Type   | Units | Description |
|------------|--------|-------|-------------|
| `L`    | double | dB    | Basic transmission loss |



## References

* [WINNER II](http://www.ero.dk/93F2FC5C-0C4B-4E44-8931-00A5B05A331B)