
-- CSEN403 Haskell's Project --

----------------------------------------------------------------
----------------------------------------------------------------
------------------  Start of Functions  ------------------------
----------------------------------------------------------------
----------------------------------------------------------------

data Item= I String deriving(Show,Eq)
data Person= U String deriving(Show,Eq)
data Rating a= NoRating | R a deriving (Show,Eq)

--------------------------------------
-----------------  dis ---------------
--------------------------------------

dis :: Eq a => [a] -> [a]
dis [] = []
dis (x:xs) = if(contains x xs == True) then dis xs else [x] ++ dis xs

contains _ []=False
contains x (h:t) = if(x==h) then True else contains x t

--------------------------------------
--------  fromRatingsToItems  --------
--------------------------------------

fromRatingsToItems :: Eq a => [(b,a,c)] -> [a]
fromRatingsToItems a = dis (getItems a)

getItems []=[]
getItems ((x,y,z):xs) = [y] ++ getItems xs   

--------------------------------------
--------  fromRatingsToUsers  --------
--------------------------------------

fromRatingsToUsers :: Eq a => [(a,b,c)] -> [a]
fromRatingsToUsers a = dis (getUsers a)

getUsers []=[]
getUsers ((x,y,z):xs) = [x] ++ getUsers xs

--------------------------------------
-------------  hasRating  ------------
--------------------------------------

hasRating :: (Eq a, Eq b) => a -> b -> [(a,b,c)] -> Bool
hasRating _ _ [] =False
hasRating user item ((x,y,z):xs) = if(user==x && item==y) then True else hasRating user item xs 

--------------------------------------
-------------  getRating  ------------
--------------------------------------

getRating :: (Eq a, Eq b) => a -> b -> [(a,b,c)] -> c
getRating _ _ [] = error "No given rating"
getRating user item ((x,y,z):xs) = if(user==x && item==y) then z else getRating user item xs 

--------------------------------------
-----------  formMatrixUser  ---------
--------------------------------------

formMatrixUser :: (Eq a, Eq b, Fractional c) => b -> [a] -> [(b,a,c)] -> [Rating c]
formMatrixUser user items ratings = getUserRating user items ratings ratings

getUserRating _ [] _ _ = []
getUserRating user (x:xs) [] b =[NoRating] ++ getUserRating user xs b b 
getUserRating user (h:t) ((x,y,z):xs) a = if(user==x && h==y) then [R z] ++ getUserRating user t a a else getUserRating user (h:t) xs a

--------------------------------------
-------------  formMatrix  -----------
--------------------------------------

formMatrix :: (Eq a, Eq b, Fractional c) => [b] -> [a] -> [(b,a,c)] -> [[Rating c]]
formMatrix [] _ _ =[]
formMatrix (x:xs) items ratings = [formMatrixUser x items ratings] ++ formMatrix xs items ratings

--------------------------------------
-----  numberRatingsGivenItem  -------
--------------------------------------

numberRatingsGivenItem :: (Fractional a, Num b) => Int -> [[Rating a]] -> b
numberRatingsGivenItem _ [] = 0
numberRatingsGivenItem n (x:xs) = if( (x!!n) /= NoRating ) then 1 + numberRatingsGivenItem n xs else numberRatingsGivenItem n xs

--------------------------------------
----------  differeneRatings  --------
--------------------------------------

differeneRatings :: Fractional a => Rating a -> Rating a -> a
differeneRatings NoRating _ = 0.0
differeneRatings _ NoRating = 0.0
differeneRatings (R n1) (R n2) = n1-n2 

--------------------------------------
------------- MatrixPairs ------------
--------------------------------------

matrixPairs :: Num a => a -> [(a,a)]
matrixPairs n = getPairs 0 0 n

getPairs first second n = if(first /= n && second /=n ) then (first,second):getPairs first (second+1) n 
														else if(first/=n && second ==n) then getPairs (first+1) 0 n
														else []

--------------------------------------
-----------  dMatrix  ----------------
--------------------------------------

dMatrix :: Fractional a => [[Rating a]] -> [a]
dMatrix (x:xs) = sumOfDiff (matrixPairs (length x)) (x:xs)

sumOfDiff [] _ = []
sumOfDiff ((i,j):t) ratings = [getSumOfList i j ratings] ++ sumOfDiff t ratings

getSumOfList _ _ [] = 0
getSumOfList i j (x:xs) = differeneRatings (x!!i) (x!!j) + getSumOfList i j xs

--------------------------------------
-------------  freqMatrix  -----------
--------------------------------------

freqMatrix :: (Num a, Fractional b) => [[Rating b]] -> [a]
freqMatrix (x:xs) = sumOfFreq (matrixPairs (length x)) (x:xs)

sumOfFreq [] _ = []
sumOfFreq ((i,j):t) ratings = [getSumFreq i j ratings] ++ sumOfFreq t ratings

getSumFreq _ _ [] = 0
getSumFreq i j (x:xs) = if( x!!i /= NoRating && x!!j /= NoRating ) then 1+getSumFreq i j xs else getSumFreq i j xs

--------------------------------------
-----------  diffFreqMatrix  ---------
--------------------------------------

diffFreqMatrix :: Fractional a => [[Rating a]] -> [a]
diffFreqMatrix ratings = getAvg (dMatrix ratings) (freqMatrix ratings)

getAvg [] [] = []
getAvg (h1:t1) (h2:t2) = [(h1/h2)] ++ getAvg t1 t2

--------------------------------------
--------------  predict --------------
--------------------------------------
--(fromIntegral $ length (getRatingMatrix l))
--((((getRatingMatrix l)!!user)!!item))
--predict :: Fractional c => [[Rating c]] -> Int -> Int -> c
predict l user item = if ((((getRatingMatrix (dis l))!!user)!!item) /= NoRating) then getRating ((fromRatingsToUsers (dis l))!!user) ((fromRatingsToItems (dis l))!!item) l else (sum (getItemsPredictions (deleteUserIndex item ((getRatingMatrix (dis l))!!user)) (getPredictedDiff (getIndex 0 (matrixPairs (length ((getRatingMatrix (dis l))!!0))) (getNeededPairs 0 (length ((getRatingMatrix (dis l))!!0)) item )) (dMatrix (deleteUserIndex user (getRatingMatrix (dis l)))) (length (deleteUserIndex user (getRatingMatrix (dis l)))))))/(fromIntegral $ (length (deleteUserIndex item ((getRatingMatrix (dis l))!!user))))

getRatingMatrix l = formMatrix (fromRatingsToUsers l) (fromRatingsToItems l) l

getItemsPredictions _ [] = []
getItemsPredictions (h:t) (x:xs) = [sumRatings h x] ++ getItemsPredictions t xs

sumRatings :: Fractional a => Rating a -> a -> a
sumRatings NoRating _ = 0.0
sumRatings (R n1) n2 = n1+n2 

getPredictedDiff [] _ _ = []
getPredictedDiff (x:xs) matrixWithoutNeededUserRating n = [(matrixWithoutNeededUserRating!!x)/(fromIntegral $ n)] ++ getPredictedDiff xs matrixWithoutNeededUserRating n


getIndex _ _ [] = []
getIndex index (h1:t1) (h2:t2) = if(h1==h2) then [index] ++ getIndex (index+1) t1 t2 else getIndex (index+1) t1 (h2:t2)

getNeededPairs counter n item = if( counter /= item && counter /= n ) then [(item,counter)] ++ getNeededPairs (counter+1) n item
																	else if(counter == item && counter /= n ) then getNeededPairs (counter+1) n item else []

-- delete the index of the item in the selected user rated items --																	
deleteUserIndex _ [] = error " Incorrect Index "
deleteUserIndex n (x:xs) = if (n/=0) then [x] ++ deleteUserIndex (n-1) xs else xs


----------------------------------------------------------------
----------------------------------------------------------------
----------------------  End of Functions  ----------------------
----------------------------------------------------------------
----------------------------------------------------------------