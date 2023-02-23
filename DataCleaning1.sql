
--Cleaning Data in SQL Queries

 select * from PortfolioProject..NashvilleHousing

 --Standardize Date Format

 select SaleDateConverted,convert(Date,SaleDate)
 from PortfolioProject..NashvilleHousing


 Update NashvilleHousing 
 set SaleDate=convert(Date,SaleDate);

 Alter Table NashvilleHousing 
 Add SaleDateConverted Date;

  Update NashvilleHousing 
 set SaleDateConverted=convert(Date,SaleDate);

 --Populate Property Address Data
  select * from PortfolioProject..NashvilleHousing
  order by ParcelID


  select a.ParcelID,a.PropertyAddress,b.ParcelId,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
  from PortfolioProject..NashvilleHousing a
  join PortfolioProject..NashvilleHousing b
  on a.ParcelID=b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null

  Update a
  set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
   from PortfolioProject..NashvilleHousing a
  join PortfolioProject..NashvilleHousing b
  on a.ParcelID=b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null

---------------------------------------------------------------------------------------------------------------------------------------------------------
  --Breaking out Address into seperate column(Address,city,state)
  select PropertyAddress from PortfolioProject..NashvilleHousing
  select
  substring (PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) as Address,
  substring (PropertyAddress, CHARINDEX(',',PropertyAddress) +1, len (PropertyAddress)) as City
  From PortfolioProject..NashvilleHousing

   

 Alter Table NashvilleHousing 
 Add PropertySplitAddress nvarchar(255);
 
 Update NashvilleHousing 
 set PropertySplitAddress=substring (PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1)

 Alter Table NashvilleHousing 
 Add PropertySplitCity nvarchar(255);

  Update NashvilleHousing 
 set PropertySplitCity=substring (PropertyAddress, CHARINDEX(',',PropertyAddress) +1, len (PropertyAddress))


select ownerAddress from PortfolioProject..NashvilleHousing
select
PARSENAME(Replace (ownerAddress,',','.'), 3),
PARSENAME(Replace (ownerAddress,',','.'), 2),
PARSENAME(Replace (ownerAddress,',','.'), 1)

from PortfolioProject..NashvilleHousing
Alter Table NashvilleHousing 
 Add ownerAddressSplitAddress nvarchar(255);

  Update NashvilleHousing 
 set ownerAddressSplitAddress=PARSENAME(Replace (ownerAddress,',','.'), 3)
 
 Alter Table NashvilleHousing 
 Add ownerAddressSplitCity nvarchar(255);

  Update NashvilleHousing 
 set ownerAddressSplitCity=PARSENAME(Replace (ownerAddress,',','.'), 2)
 Alter Table NashvilleHousing 
 Add  ownerAddressSplitState nvarchar(255);

  Update NashvilleHousing 
 set ownerAddressSplitState=PARSENAME(Replace (ownerAddress,',','.'), 1)

 -------------------------------------------------------------------------------------------------------------------------------------------
 --Change y and N to yes and no at 'Sold As Vacant' Field
 select Distinct(SoldAsVacant),count(SoldAsVacant) from PortfolioProject..NashvilleHousing
 Group by SoldAsVacant
 Order by 2
select SoldAsVacant
,CASE
WHEN SoldAsVacant ='Y' THEN 'YES'
WHEN SoldAsVacant ='N' THEN 'No'
ELSE SoldAsVacant
END
from PortfolioProject..NashvilleHousing

 Update PortfolioProject..NashvilleHousing
 set SoldAsVacant =
 CASE
 WHEN SoldAsVacant ='Y' THEN 'YES'
 WHEN SoldAsVacant ='N' THEN 'No'
 ELSE SoldAsVacant
 END
 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 --Remove Duplicate
 With RowNumCTE as(
 select *,
 ROW_NUMBER() over (
 Partition by ParcelID,
              PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  order by
			  UniqueID) Row_Num
			  From PortfolioProject..NashvilleHousing
			  --Order by ParcelID
			  )
select * from RowNumCTE 
where Row_Num>1
--order by PropertyAddress

--------------------------------------------------------------------------------------------
--Delete Unused Columns
select * from PortfolioProject..NashvilleHousing

Alter Table PortfolioProject..NashvilleHousing
Drop Column PropertyAddress,SaleDate,OwnerAddress,TaxDistrict

