<@pp.dropOutputFile />
<#list dalgen.doMappers as doMapper>
<@pp.changeOutputFile name = "/main/java/${doMapper.classPath}/${doMapper.className}.java" />
package ${doMapper.packageName};

<#list doMapper.importLists as import>
import ${import};
</#list>
import com.tollge.business.util.DaoUtil;
import com.tollge.sql.SqlSession;
import io.smallrye.mutiny.Multi;
import io.smallrye.mutiny.Uni;
import io.smallrye.mutiny.tuples.Tuple2;
import io.vertx.mutiny.sqlclient.RowSet;
import io.vertx.mutiny.sqlclient.Tuple;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import java.util.List;
import java.util.Map;

/**
 *
 * The Table ${doMapper.tableName!}.
 * ${doMapper.desc!}
 */
@ApplicationScoped
public class ${doMapper.className}{

    @Inject
    io.vertx.mutiny.mysqlclient.MySQLPool client;

    public Uni<${doMapper.javaName}DO> one(${doMapper.javaName}DO doName) {
            SqlSession sqlSession = DaoUtil.fetchSql("${doMapper.javaName}.one", doName.toMap());
            return client.preparedQuery(sqlSession.getSql()).execute(Tuple.wrap(sqlSession.getParams()))
                    .onItem().transform(RowSet::iterator)
                    .onItem().transform(iterator -> iterator.hasNext() ? ${doMapper.javaName}DO.convertFromRow(iterator.next()) : null);
        }

        public Uni<List<${doMapper.javaName}DO>> list(${doMapper.javaName}DO doName) {
            SqlSession sqlSession = DaoUtil.fetchSql("${doMapper.javaName}.list", doName.toMap());
            return client.preparedQuery(sqlSession.getSql()).execute(Tuple.wrap(sqlSession.getParams()))
                    .onItem().transformToMulti(set -> Multi.createFrom().iterable(set))
                    .onItem().transform(${doMapper.javaName}DO::convertFromRow)
                    .collectItems().asList();
        }

        public Uni<Long> count(${doMapper.javaName}DO doName) {
            SqlSession sqlSession = DaoUtil.fetchSql("${doMapper.javaName}.count", doName.toMap());
            return client.preparedQuery(sqlSession.getSql()).execute(Tuple.wrap(sqlSession.getParams()))
                    .onItem().transform(pgRowSet -> pgRowSet.iterator().next().getLong(0));
        }

        public Uni<Tuple2<Long, List<${doMapper.javaName}DO>>> page(${doMapper.javaName}DO doName) {
            return Uni.combine().all().unis(count(doName), list(doName)).asTuple();
        }


        public Uni<Long> save(${doMapper.javaName}DO doName) {
            SqlSession sqlSession = DaoUtil.fetchSql("${doMapper.javaName}.save", doName.toMap());
            return client.preparedQuery(sqlSession.getSql()).execute(Tuple.wrap(sqlSession.getParams()))
                    .onItem().transform(pgRowSet -> pgRowSet.iterator().next().getLong("id"));
        }

        public Uni<Boolean> update(${doMapper.javaName}DO from, ${doMapper.javaName}DO to) {
            Map<String, Object> fromMap = from.toMap();
            for (Map.Entry<String, Object> entry : to.toMap().entrySet()) {
                fromMap.put("to_"+entry.getKey(), entry.getValue());
            }

            SqlSession sqlSession = DaoUtil.fetchSql("${doMapper.javaName}.update", fromMap);
            return client.preparedQuery(sqlSession.getSql()).execute(Tuple.wrap(sqlSession.getParams()))
                    .onItem().transform(pgRowSet -> pgRowSet.rowCount() > 0);
        }

        public Uni<Boolean> delete(Long id) {
            ${doMapper.javaName}DO u = new ${doMapper.javaName}DO();
            u.setId(id);
            SqlSession sqlSession = DaoUtil.fetchSql("${doMapper.javaName}.deleteById", u.toMap());
            return client.preparedQuery(sqlSession.getSql()).execute(Tuple.wrap(sqlSession.getParams()))
                    .onItem().transform(pgRowSet -> pgRowSet.rowCount() == 1);
        }
}
</#list>