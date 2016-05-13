package edu.inlab.service;

import edu.inlab.models.UserTask;

import java.util.List;

/**
 * Created by inlab-dell on 2016/5/13.
 */
public interface UserTaskService {
    void saveUserTask(UserTask userTask);
    void updateUserTask(UserTask userTask);
    UserTask getById(int id);
    List<UserTask> getByUserId(int userId, int size);
    List<UserTask> getByUserId(int userId, int startTaskId, int size);
    UserTask getByUserAndTaskId(int userId, int taskId);
}