# Spiral Sequences 'distance:*'

Return sequence coordinates in spiral order. Start from (0,0). 
Variant 'distance:clockwise' of spiral sequence continue with 
top (0,-1), right (1,0), bottom (0,1) and left (-1,0). Then 
top-right (1,-1), bottom-right, ...

## Example for 'distance::clockwise'

Variant 'distance::clockwise' starts with 0,0 and continue with most 
nearby elements in clockwise order. Note that for example distance 
from 0,0 to 1,0 is shorten than to from 0,0 to 1,1 as 
(1^2+0^2)^1/2 <(1^2+1^2)^1/2. 

The first five elements
````

           2
         5 1 3
           4  
````

next four
````
         9 2 6
         5 1 3
         8 4 7

````

and all others to fill 5x5 matrix.
````
    25 21 10 14 22
    20  9  2  6 15
    13  5  1  3 11
    19  8  4  7 16
    24 18 12 17 23

````

## Algorithm explanation

Lets start with hardcoded begin of the sequence: magenta, red, blue.

![3x3](./distance-variants-3x3.png)

We can continue with 4x red, 4x blue, 8x green

![5x5](./distance-variants-5x5.png)

but let's first skip two layers to visualize the pattern clearly. You 
see 4x red will be the first and 4x blue the last. It's the same also
one and two steps from the core.

![9x9-a](./distance-variants-9x9-a.png)

Lets skip to the outer most layer first to visualize that he have again
eight dark green positions. And near them also two more free space
before we read the blue corner.

![9x9-b](./distance-variants-9x9-b.png)

And before we reach the blue corner there are also normal green and
light green positions.

![9x9-c](./distance-variants-9x9-c.png)

Now we can return back to see that dark green emerged two layers sooner.
Whole pattern and algorithm is visualized by colors in these order:
magenta, red, green from dark to light and finally blue.

![9x9](./distance-variants-9x9.png)
