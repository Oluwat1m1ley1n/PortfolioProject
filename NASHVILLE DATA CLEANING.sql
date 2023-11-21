/*

Cleaning Data in SQL QUERIES

*/

------------------------------------------------------------------------

Select*
From PortFolio.dbo.NashvilleHousing

--Standard Date Format
Select SaleDateConverted, CONVERT (date,SaleDate)
From PortFolio.dbo.NashvilleHousing   

Update  NashvilleHousing
Set SaleDate = CONVERT (date,SaleDate)

ALTER TABLE NashvilleHousing 
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted =CONVERT (Date,SaleDate)

--Populate Property Address Data


Select *
From NashvilleHousing
--Where PropertyAddress is null
Order by ParcelID


Select  b.ParcelID,b.PropertyAddress,c.ParcelID,c.PropertyAddress,ISNULL(b.PropertyAddress,c.PropertyAddress)
From PortFolio.dbo.NashvilleHousing b
JOIN PortFolio.dbo.NashvilleHousing c 
     on b.ParcelID = c.ParcelID
	 AND b.[UniqueID ]<> c.[UniqueID ]
Where b.PropertyAddress is null

UPDATE b
Set PropertyAddress=ISNULL(b.PropertyAddress,c.PropertyAddress)
From PortFolio.dbo.NashvilleHousing b
JOIN PortFolio.dbo.NashvilleHousing c 
     on b.ParcelID = c.ParcelID
	 AND b.[UniqueID ]<> c.[UniqueID ]
Where b.PropertyAddress is null


-----------------------------------------------------------------------------


 --Breaking out Address into Individual Columns (Address,City,State)
 
Select PropertyAddress
From NashvilleHousing
--Where PropertyAddress is null
--Order by ParcelID

SELECT 
SUBSTRING (PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) as Address
, SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress) +1 ,LEN(PropertyAddress)) as Address

From Portfolio.dbo.NashvilleHousing 


ALTER TABLE Portfolio.dbo.NashvilleHousing
Add PropertyAddressSplits NVarchar (255)


Update NashvilleHousing
SET PropertyAddressSplits  =SUBSTRING (PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE NashvilleHousing 
Add PropertySplitCities NVarchar (255)

Update NashvilleHousing
Set  PropertySplitCities =SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress) +1 ,LEN(PropertyAddress)) 

SELECT *
FROM NashvilleHousing

 

SELECT OwnerName
FROM NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerName,',', ','),1)
,PARSENAME(REPLACE(OwnerName,',', ','),2)
,PARSENAME(REPLACE(OwnerName,',', ','),3)

FROM NashvilleHousing


SELECT OwnerName
FROM NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerName,',', ','),1)
,PARSENAME(REPLACE(OwnerName,',', ','),2)
,PARSENAME(REPLACE(OwnerName,',', ','),3)

FROM NashvilleHousing




SELECT OwnerAddress
FROM NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ' , ' , ','),3)
,PARSENAME(REPLACE(OwnerAddress, ' , ',', '),2)
,PARSENAME (REPLACE(OwnerAddress, ',' ,','  ) ,+1)
FROM PortFolio.dbo.NashvilleHousing



ALTER TABLE Portfolio.dbo.NashvilleHousing
Add OwnerAddressSplits NVarchar (255)


Update NashvilleHousing
SET OwnerAddressSplits  =PARSENAME(REPLACE(OwnerAddress, ' , ' , ','),3)

ALTER TABLE NashvilleHousing 
Add OwnerSplitCities NVarchar (255)

Update NashvilleHousing
Set  OwnerSplitCities =PARSENAME(REPLACE(OwnerAddress, ' , ',', '),2)


ALTER TABLE NashvilleHousing 
Add OwnerSplitState NVarchar (255)

Update NashvilleHousing
Set  OwnerSplitState =PARSENAME(REPLACE(OwnerAddress, ' , ',', '),1)

Select *
From NashvilleHousing
----------------------------------------------------------------------------------

-- Change Y and N to YES and NO in the 'Sold as Vacant 'field

SELECT DISTINCT(SoldAsVacant),count(SoldAsVacant)
FROM NashvilleHousing
GROUP by SoldAsVacant
ORDER by 2

SELECT SoldAsVacant
,CASE WHEN  SoldAsVacant= 'Y' Then 'YES'
      WHEN SoldAsVacant  = 'N' Then 'NO'
	  ELSE SoldAsVacant 
	  END
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN  SoldAsVacant= 'Y' Then 'YES'
      WHEN SoldAsVacant  = 'N' Then 'NO'
	  ELSE SoldAsVacant 
	  END

--------------------------------------------------------------------------------------------

--Remove Duplicates

WITH RowNumCTE AS( 
SELECT *,
   ROW_NUMBER() OVER(
   PARTITION BY ParcelID,
   PropertyAddress,
   SalesDate,
   SalePrice,
   LegalReference
   ORDER BY 
   UniqueID
   ) row_num
  
FROM NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
 Where row_num>  1
--order by PropertyAddress


------------------------------------------------------------------------------------------------------

--Delete unused Columns

Select *
From NashvilleHousing

Alter Table NashvilleHousing
Drop Column SaleDate,SalesDateConvertes,SalesDateConverteds,Propertysplitaddress
,Property,Propertyaddresssplitted

Alter Table NashvilleHousing
Drop Column Propertyaddresssplits,SalesDateConverted
,Propertysplitcity,SalesDate

Alter Table NashvilleHousing
Drop Column OwnerSplitCities,OwnerAddressSplits

