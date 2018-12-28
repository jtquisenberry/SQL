--DECLARE @x VARBINARY(4)
--Declare @y nvarchar(100)
--SELECT  @x = CAST(8526 as VARBINARY(2))
--SELECT @x AS VarBinaryValue
--select @y = cast(@x as nvarchar(100))
--select @y as yyy
--
--SELECT 'Int -> Hex' 
--SELECT CONVERT(VARBINARY(8), 16777215) 
--
--SELECT 'Hex -> Int' 
--SELECT CONVERT(INT, 0xFFFFFF)
--
--select 0xFFFFFF


Declare @HexString VARCHAR(255)
Declare @HexString2 VARCHAR(255)
Declare @HexLen INT
Declare @HexLenTotal INT
Declare @HexInt INT
Declare @HexLenMod4 INT
Declare @Quad INT
Declare @Pair INT

Select @HexString = '020001'
Select @HexLen = Len(@HexString)
If (@HexLen = 6) Select @HexString2 = '00' + @HexString
Select @HexLenMod4 = @HexLen%4
Select @HexString, @HexLen, @HexString2, Substring(@HexString2,1,2), @HexLenMod4
While @HexLenMod4 > 0
	Begin
		Select @HexString = '0' + @HexString
		Select @HexLenMod4 = @HexLenMod4 - 1

	End
Select @HexLen = Len(@HexString)
Select @Quad = @HexLen/4
Select @Quad
Select @HexInt = 0
Select @HexLenTotal = @HexLen
While @HexLen > 0
	Begin
		Select @HexInt = @HexInt + (substring(@HexString,@HexLen,1)) * Power(16, (@HexLenTotal - @HexLen))
		--Select (substring(@HexString,@HexLen,1)), @HexLenTotal - @HexLen, 16 ^ (@HexLenTotal - @HexLen), Power(16, (@HexLenTotal - @HexLen))
		Select @HexLen = @HexLen - 1
	End


Select @HexInt as HexInt, convert(varbinary(24), @HexInt)


select dbo.base2int('41', 16)