<@pp.dropOutputFile />
<#import "../lib/lib.ftl" as lib/>
<#list dalgen.xmlMappers as xmlMapper>
<@pp.changeOutputFile name = "/main/resources/${xmlMapper.doMapper.classPath}/${xmlMapper.table.javaName}.md" />

## columns
```sub
<#list xmlMapper.table.columnList as column>
${column.sqlName?lower_case}<#if column_has_next>,</#if>
</#list>
```

## conditions
```sub
where 1=1
<#list xmlMapper.table.columnList as column>
?if ${column.javaName} isNotNull??
    and ${column.sqlName}=#${column.javaName}#
if?
</#list>
```

## one
> 注释:查询一个
```sql
select ?sub ${xmlMapper.table.javaName}.columns sub?
from ${xmlMapper.table.sqlName}
?sub ${xmlMapper.table.javaName}.conditions sub?
limit 1
```

## list
> 注释:查询列表
```sql
select ?sub ${xmlMapper.table.javaName}.columns sub?
from ${xmlMapper.table.sqlName}
?sub ${xmlMapper.table.javaName}.conditions sub?
```

## count
> 注释:查询数量
```sql
select count(*)
from ${xmlMapper.table.sqlName}
?sub ${xmlMapper.table.javaName}.conditions sub?
```

## save
> 注释:保存
```sql
insert into ${xmlMapper.table.sqlName} (?sub ${xmlMapper.table.javaName}.columns sub?)
values(
<#list xmlMapper.table.columnList as column>
#${column.javaName}#<#if column_has_next>,</#if>
</#list>
)
```

## update
> 注释:更新
```sql
update ${xmlMapper.table.sqlName}
set
<#list xmlMapper.table.columnList as column>
?if #to_${column.javaName}# isNotNull??
    ${column.sqlName}=#to_${column.javaName}#,
if?
</#list>
id=id
?sub ${xmlMapper.table.javaName}.conditions sub?
```

## deleteById
> 注释:根据id删除
```sql
delete from ${xmlMapper.table.sqlName}
where id = #id#
```
</#list>