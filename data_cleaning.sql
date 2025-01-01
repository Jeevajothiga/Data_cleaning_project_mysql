---viewing the dataset
select*from layoffs;

---creating a duplicate dataset called layoffs_staging like layoffs,
---We want a table with the raw data in case something happens
create table layoffs_staging
like layoffs; ---now empty table skeleton will be created like layoffs

---viewling the empty table
select * from layoffs_staging;

---now inserting the values from the layoffs table into duplicate table layoffs_staging
insert into layoffs_staging
select * from layoffs

-- now when we are data cleaning we usually follow a few steps
-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. Look at null values and see what 
-- 4. remove any columns and rows that are not necessary - few ways



-- 1. Remove Duplicates
-- First let's check for duplicates
---THIS A METHOD TO FIND THE DUPLICATES
---Is to create a new column and add those row numbers in. Then delete where row numbers are over 2, then delete that column
---CREATING A TABLE CALLED LAYOFFFS_STAGING2 INCLUDING A ROW_NUM COLUMN
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num`INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

---NOW INSERTING THE VALUES FROM LAYOFFS_STAGING AND ADDING ROW NUMBER
insert into layoffs_staging2
SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		world_layoffs.layoffs_staging;

select* from layoffs_staging2
where row_num > 1;
---NOW DELETING THE ROWNUM GREATER THAN 1
DELETE
from layoffs_staging2
where row_num > 1;


