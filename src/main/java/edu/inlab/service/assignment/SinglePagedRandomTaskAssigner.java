package edu.inlab.service.assignment;

import edu.inlab.models.Microtask;
import edu.inlab.models.Task;
import edu.inlab.models.UserMicroTask;
import edu.inlab.models.UserTask;
import edu.inlab.service.TaskService;
import edu.inlab.service.UserMicrotaskService;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.security.access.method.P;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Random;

/**
 * Created by inlab-dell on 2016/12/2.
 * 单页随机任务分配器
 * 页面模板固定，但是内容物是随机分配的
 * 目前供给Grid-choice Render使用
 *
 * params = {
 *     "mtask_size": 一个任务包含的问题数量,
 *     "N": N个候选项,
 *     "K": 选出K个,
 *     "nRows": 显示的行数,
 *     "candidates":
 *      [
 *          {"image": 内部图片文件名, "text":文字描述}, ...
 *      ]
 * }
 *
 * params里的candidates生成的事情交给前端做，加个按钮. 读取csv或是excel.
 */
@Component
@ComponentScan(basePackages = "edu.inlab")
public class SinglePagedRandomTaskAssigner implements MicroTaskAssigner {
    @Autowired
    TaskService taskService;

    @Autowired
    UserMicrotaskService userMicrotaskService;

    @Override
    public Microtask assignNext(UserTask userTask) throws RuntimeException {
        Task task = taskService.findById(userTask.getTaskId());
        JSONObject taskParams = new JSONObject(task.getParams());
        Long microtaskSizeLimit = taskParams.getLong("mtask_size");
        Long finishedCount = userMicrotaskService.getCountByUserTaskId(userTask.getId());

        if(finishedCount >= microtaskSizeLimit)
            return null;

        Microtask microtaskToRender = task.getRelatedMictorasks().get(0);
        /*
        * Push items into task template
        * */
        JSONArray candidates = taskParams.getJSONArray("candidates");

        List<Integer> selectedIndices = reserviorSample(candidates.length()
                , taskParams.getInt("N")+1);    // 1 reference + N candidates
        Collections.shuffle(selectedIndices);

        JSONObject templateJson = new JSONObject(taskParams);
        templateJson.remove("candidates");
        templateJson.put("ref_item", candidates.getJSONObject(selectedIndices.get(0)));
        for(int i=1; i<selectedIndices.size(); i++){
            templateJson.put("item", candidates.getJSONObject(selectedIndices.get(i)));
        }
        microtaskToRender.setTemplate(templateJson.toString());
        return microtaskToRender;
    }

    private List<Integer> reserviorSample(int N, int k){
        List<Integer> results = new ArrayList<>(k);
        Random random = new Random();
        for(int i=0; i<N; i++){
            if(i < k)
                results.set(i, i);
            else {
                int next = random.nextInt(i+1);
                if(next < k)
                    results.set(next, i);
            }
        }
        return results;
    }

    @Override
    public void onUserMicrotaskSubmit(UserMicroTask userMicroTask, Task task) {

    }
}
