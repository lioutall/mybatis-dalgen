<@pp.dropOutputFile />
<#list dalgen.dos as DO>
<@pp.changeOutputFile name = "/main/java/${DO.classPath}/${DO.className}.java" />
package ${DO.packageName};

<#list DO.importLists as import>
import ${import};
</#list>
import lombok.*;

/**
 * The table ${DO.desc}
 */
@Getter
@Setter
@NoArgsConstructor
@TollgeDO
@ToMap
@FromMap
public class ${DO.className}{

    <#list DO.fieldses as fields>
    /**
     * ${fields.name} ${fields.desc}.
     */
    private ${fields.javaType} ${fields.name};
    </#list>

}
</#list>