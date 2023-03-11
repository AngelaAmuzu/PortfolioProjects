
--Cleaning Data in SQL Queries

select*
from PortfolioProject..NashvilleHousing

--Standardize Date Format

select SaleDateConverted, CONVERT(Date,SaleDate)
from PortfolioProject..NashvilleHousing

update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NASHVILLEHOUSING 
ADD SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted = CONVERT(date,SaleDate)

--Populate Property Address Date

select *
from PortfolioProject..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

--Breaking out Address into Individual Columns (Address, City, State)


select PropertyAddress
from PortfolioProject..NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(propertyaddress)) as Address

From PortfolioProject..NashvilleHousing


ALTER TABLE NASHVILLEHOUSING 
ADD PropertySplitAddress NVARCHAR(255);

update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NASHVILLEHOUSING 
ADD PropertySplitCity Nvarchar(255);

update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(propertyaddress))


select *
From PortfolioProject..NashvilleHousing



select OwnerAddress
From PortfolioProject..NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
From PortfolioProject..NashvilleHousing


ALTER TABLE NASHVILLEHOUSING 
ADD OwnerSplitAddress NVARCHAR(255);

update NashvilleHousing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

ALTER TABLE NASHVILLEHOUSING 
ADD OwnerSplitCity Nvarchar(255);

update NashvilleHousing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER TABLE NASHVILLEHOUSING 
ADD OwnerSplitState Nvarchar(255);

update NashvilleHousing
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)


select *
From PortfolioProject..NashvilleHousing


--Change Y and N to Yes and No in "Sold as Vacant" field

Select distinct(SoldAsVacant), count(SoldAsVacant)
From PortfolioProject..NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, case when SoldAsVacant = 'y' THEN 'YES'
       WHEN SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
From PortfolioProject..NashvilleHousing


UPDATE NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'y' THEN 'YES'
       WHEN SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END


--Remove Duplicates

WITH RowNumCTE AS(
select *,
     row_number() over (
     partition by parcelId,
				  PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  ORDER BY
				    uniqueID
				    ) ROW_NUM

From PortfolioProject..NashvilleHousing
--ORDER BY ParcelID
)
SELECT *
From RowNumCTE
where row_num > 1
--order by PropertyAddress



--Delete Unused Columns


select *
From PortfolioProject..NashvilleHousing


Alter table PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


Alter table PortfolioProject..NashvilleHousing
DROP COLUMN saledate
