--找出尚未建立的班級
select NEWID() ClassID, a.DayfgID, a.ClassTypeID, a.UnitID
	, '00000000-0000-0000-0000-000000000000' StudyGroupID, NULL
	, (select top 1 SUBSTRING(d.ClassName, 1, LEN(d.ClassName) - 2) + b.GradeName + RIGHT(d.ClassName, 1)
		from tClass d
		where a.DayfgID = d.DayfgID
			and a.ClassTypeID = d.ClassTypeID
			and a.UnitID = d.UnitID
			and a.ClassNo = d.ClassNo) ClassName
	, (select top 1 SUBSTRING(d.ClassName, 1, LEN(d.ClassName) - 2) + b.GradeName + RIGHT(d.ClassName, 1)
		from tClass d
		where a.DayfgID = d.DayfgID
			and a.ClassTypeID = d.ClassTypeID
			and a.UnitID = d.UnitID
			and a.ClassNo = d.ClassNo) ClassAlias
	, NULL ClassENGName
	, 1 state
	, b.Grade
	, (select top 1 d.ClassNo
		from tClass d
		where a.DayfgID = d.DayfgID
			and a.ClassTypeID = d.ClassTypeID
			and a.UnitID = d.UnitID
			and a.ClassNo = d.ClassNo) ClassNo
	, NULL UnitCode
	, NULL ClassType
	, NULL Dayfg, NULL StudyGroup, NULL Class, NULL IsExct, NULL ClassIDOld
	, NULL IsExistStd, NULL ClassUniqueNo
from (
	select distinct b.DayfgID, b.ClassTypeID, b.UnitID, b.ClassNo 
	from tUnitClassType a
	join tClass b on a.DayfgID = b.DayfgID
		and a.ClassTypeID = b.ClassTypeID
		and a.UnitID = b.UnitID
	where b.DayfgID in (
		select DayfgID from tDayfg
		where DayfgName in ('進修學院', '進專部')
	)
) a
--年級表
, (
	select distinct number Grade
		, case number 
			when 1 then '一'
			when 2 then '二'
			when 3 then '三'
			when 4 then '四'
			when 5 then '五'
			when 6 then '六'
			when 7 then '七'
			when 8 then '八'
			when 9 then '九'
			when 10 then '十' else '' end GradeName
	from master..spt_values
	where number >= 1 and number <= 10
) b
--排除已存在班級
where not exists (
	select * from tClass c
	where a.DayfgID = c.DayfgID
		and a.ClassTypeID = c.ClassTypeID
		and a.UnitID = c.UnitID
		and b.Grade = c.Grade
		and a.ClassNo = c.ClassNo
) 
--例外排除
and a.ClassNo not in ('跨')
