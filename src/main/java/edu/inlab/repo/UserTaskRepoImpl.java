package edu.inlab.repo;

import edu.inlab.models.UserTask;
import org.hibernate.Criteria;
import org.hibernate.criterion.CriteriaSpecification;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by inlab-dell on 2016/5/13.
 */
@Repository("userTaskRepo")
public class UserTaskRepoImpl extends AbstractDao<Integer, UserTask> implements UserTaskRepository {
    public void save(UserTask userTask) {
        persist(userTask);
    }

    public UserTask getById(int id) {
        return getByKey(id);
    }

    public List<UserTask> getByUserId(int userId, int startTaskId, int size) {
        List<UserTask> userTasks = getSession().createCriteria(UserTask.class)
                .add(Restrictions.eq("userId", userId))
                .add(Restrictions.ge("taskId", startTaskId))
                .setMaxResults(size)
                .list();
        return userTasks;
    }

    public List<UserTask> getByUserAndTaskId(int userId, int taskId) {
        List<UserTask> userTasks = getSession().createCriteria(UserTask.class)
                .add(Restrictions.eq("userId", userId))
                .add(Restrictions.eq("taskId", taskId))
                .list();
//        if(userTasks.size() > 0){
//            return userTasks.get(0);
//        }
// 160526 Support the same task to be claimed by one user for multiple times
        return userTasks;
    }

    public Number getUserClaimedCount(int userId) {
        Number cnt = (Number) getSession().createCriteria(UserTask.class)
                .add(Restrictions.eq("userId", userId))
                .setProjection(Projections.rowCount())
                .uniqueResult();
        return cnt;
    }


    public List<UserTask> getUserUnfinishedTasks(int userId) {
        List<UserTask> userTasks = getSession().createCriteria(UserTask.class)
                .add(Restrictions.eq("userId", userId))
                .add(Restrictions.eq("state", 0))
                .list();
        return userTasks;
    }

    public Number getUserFinishedCount(int userId) {
        Number cnt = (Number) getSession().createCriteria(UserTask.class)
                .add(Restrictions.eq("userId", userId))
                .add(Restrictions.eq("state", UserTask.STATE_FINISHED))
                .setProjection(Projections.rowCount())
                .uniqueResult();
        return cnt;
    }

    public UserTask getUnfinished(int userId, int taskId) {
        UserTask retTask = (UserTask) getSession().createCriteria(UserTask.class)
                .add(Restrictions.eq("userId", userId))
                .add(Restrictions.eq("taskId", taskId))
                .add(Restrictions.eq("state", UserTask.STATE_CLAIMED))
                .uniqueResult();
        return retTask;
    }

    public UserTask getUnfinished(String mturkId, int taskId) {
        UserTask userTask = (UserTask) getSession().createCriteria(UserTask.class)
                .add(Restrictions.eq("mturkId", mturkId))
                .add(Restrictions.eq("taskId", taskId))
                .add(Restrictions.eq("state", UserTask.STATE_CLAIMED))
                .uniqueResult();
        return userTask;
    }

    public List<UserTask> getByMturkIdAndTaskId(String mturkId, int taskId) {
        List<UserTask> userTasks = getSession().createCriteria(UserTask.class)
                .add(Restrictions.eq("userType", UserTask.USERTYPE_MTURK))
                .add(Restrictions.eq("mturkId", mturkId))
                .add(Restrictions.eq("taskId", taskId))
                .list();
        return userTasks;
    }

    public List<UserTask> getFinishedOrExpired(String mturkId, int taskId){
        Criteria criteria = getSession().createCriteria(UserTask.class);
        Criterion state_finished = Restrictions.eq("state", UserTask.STATE_FINISHED);
        Criterion state_expired = Restrictions.eq("state", UserTask.STATE_EXPIRED);
        List<UserTask> userTasks = criteria.add(Restrictions.eq("mturkId", mturkId))
                .add(Restrictions.eq("taskId", taskId))
                .add(Restrictions.or(state_expired, state_finished))
                .list();
        return userTasks;
    }

    @Override
    public List<UserTask> getAllUnfinished() {
        return createEntityCriteria().add(Restrictions.eq("state", UserTask.STATE_CLAIMED))
                .list();
    }
}
