select cpx, convert(binary, '0x' + cpx) from ucd21

select cpx, cast('0x' + cpx as binary) from ucd21

create function base2int( @num varchar(16), @radix tinyint )
returns bigint
as
begin
    declare @ret bigint; set @ret = 0
    declare @chars char(16); set @chars = '0123456789ABCDEF'
    declare @base bigint; set @base = 1
    declare @i tinyint; set @i = len(@num)
    declare @pos tinyint

    while @i >= 1 and @ret is not null
    begin
        set @pos = charindex(substring(@num, @i, 1), @chars)
        if @pos = 0
            set @ret = null
        else
            set @ret = @ret + @base * (@pos-1)

        set @i = @i-1
        set @base = @base * @radix
    end

    return @ret
end
GO

select dbo.base2int('51', 16)

select (0x0051) as hexa, cast(0xD1F9 as nvarchar) as deca