package edu.inlab.repo;

import edu.inlab.models.UserTask;
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

    public UserTask getByUserAndTaskId(int userId, int taskId) {
        List<UserTask> userTasks = getSession().createCriteria(UserTask.class)
                .add(Restrictions.eq("userId", userId))
                .add(Restrictions.eq("taskId", taskId))
                .list();
        if(userTasks.size() > 0){
            return userTasks.get(0);
        }
        return null;
    }
}
