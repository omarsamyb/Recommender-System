# Recommender-System
The aim of the project is to provide an implementation of a Recommender System based on Collaborative Filtering.

### Project Description

Collaborative Filtering is one of the techniques used in recommender systems. The aim of the project is
to provide an implementation of a recommender system based on collaborative filtering.
The technique is based on the user-item ranking. The similarity between objects is used to predict missing
user-item rankings. In more details, this is how the technique work:
```
a) Users give ratings for some of the items.
b) Similarities between items are calculated.
c) The algorithm also takes into account the users who rated the same item to calculate similarities.
d) The system then predicts user-item ratings.
```
### Example
For example, if we find that on average people rate item 2 with 1 more than item 3 and they give the
same rating for both items 1 and 2. In case we know that a user rated item 1 with 4 and rated item 3
with 2. In case the user did not rate item 2, it could be estimated as follows:
* According to item 3, it is 2 + 1 = 3.

* According to item 1, it is 4
The rating is calculated as the average between 3 and 4 (3:5).

### Bigger Example
```
        Item 1 | Item 2 | Item 3
User A |  3    |    5   |   ?
User B |  4    |    3   |   3
```
In the example shown above, user A rated item 1 with and item 2 with 5 but did not rate item 3. Whereas,
user B rated items 1, 2 and 3 with the values 4, 3 and 3 respectively. In case we need to predict the rating
user A would give to item 3 the follows should be done:
```
a) We will be relying on user B since according to the data we have, this is the only user who rated
item 3.

b) We will try o find a pattern between the way user B rated item 3 and relate it to the rating user B
gave to the other items

c) The differences between the rating given to item 3 and the ratings given to the rest of the items is
calculated as follows:
  1. User B rated item 1 with 4 and item 3 with 3. Thus the difference is 3 - 4 = -1.
  2. User B rated item 2 with 3 and item 3 with 3. Thus the difference is 3 - 3 = 0.
  
d) The calculated differences will be used to project a possible estimate for the rating that user A
might give to item 3 similar to the previous example:
  1. If we use the difference calculated for item 1, the rating would be 3 - 1 = 2
  2. If we use the difference calculated for item 2, the rating would be 5 + 0 = 5.
  3. We thus use the avergae: (5 + 2)/2 = 3.5.
```
