<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: inlab-dell
  Date: 2016/6/13
  Time: 10:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="progress">
    <div id="progBarSaveAll" class="progress-bar progress-bar-striped progress-bar-success active" role="progressbar" style="width: 50%">
        <span></span>
    </div>
</div>
<div class="container">
    <div class="row">
        <div class="col-sm-9">
            <h4>${task.title}:任务配置</h4>
        </div>
        <div class="col-sm-3">
            <button id="btnSaveAll" type="button" class="btn btn-success pull-right">保存并提交配置</button>
        </div>
    </div>
    <div class="row" style="margin-top: 0.5rem;">
        <div class="col-sm-12">
            <!-- nav tabs-->
            <ul class="nav nav-tabs" role="tablist">
                <!-- Control Panel -->
                <li id="control-li" role="presentation" class="active" data-id="control">
                    <a href="#control" aria-controls="control" role="tab" data-toggle="tab">设置</a>
                </li>
                <!-- Existing microtasks -->
                <c:choose>
                    <c:when test="${task.mode eq 2}">
                        <!-- Sequenced microtask assignment -->
                        <c:forEach items="${microtaskSeq}" var="mtaskId">
                            <li role="presentation" id="${mtaskId}-li">
                                <a href="#${mtaskId}" aria-controls="${mtaskId}" role="tab" data-toggle="tab">#${mtaskId}</a>
                            </li>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <!-- Other modes that does not care about the sequence -->
                        <c:forEach items="${microtasks}" var="microtask">
                            <li role="presentation" id="${microtask.id}-li">
                                <a href="#${microtask.id}" aria-controls="${microtask.id}" role="tab" data-toggle="tab">#${microtask.id}</a>
                            </li>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                <!-- `+` button -->
                <li role="presentation" id="tabInsert">
                    <a href="#" aria-controls="add" role="tab" id="btnTabAdd">+</a>
                </li>
            </ul>

            <!-- Tab panes -->
            <div class="tab-content" style="padding-top: 0.5rem;">
                <div role="tabpanel" class="tab-pane active" id="control">
                    <input type="hidden" id="varTaskMode" value="${task.mode}">
                    <div class="row">
                        <div class="col-sm-12">
                            <span>批量导入配置文件</span>
                            <a class="btn btn-default" href="#" role="button">导入</a>
                        </div>
                        <div class="col-sm-12">
                            <p>批量上传图片</p>
                            <form action="<c:url value="/file/batchUpload"/>" id="formFileBatch" enctype="multipart/form-data" class="dropzone">
                                <input type="hidden" id="hiddenUploadToken" name="batchUploadToken" value="${uploadToken}">
                            </form>
                            <p>已有图片：</p>
                            [<c:forEach items="${files}" var="fileName">
                                <a href="<c:url value="/static/img/upload/task/${task.id}/${fileName}"/>" target="_blank">${fileName}</a>&nbsp;
                            </c:forEach>]
                        </div>
                        <c:if test="${task.mode eq 2}">
                            <div class="col-sm-12">
                                <h4>顺序任务配置</h4>
                                <a id="btnSeqConfigSave" class="btn btn-primary" href="#" role="button">保存微任务顺序</a>
                                <span class="paramSaveState"></span>
                                <input type="hidden" id="varTaskParams" value="${task.params}">
                            </div>
                        </c:if>
                        <c:if test="${task.mode eq 1}">
                            <div class="col-sm-12">
                                <h4>随机任务配置</h4>
                                <div class="col-sm-3">
                                    <span>随机任务数量: </span>
                                </div>
                                <div class="col-sm-3">
                                    <input type="text" class="form-control" id="inputTaskParams" value="">
                                    <input type="hidden" id="hiddenRandTaskParams" value='${task.params}'>
                                </div>
                                <div class="col-sm-6">
                                    <a id="btnRandConfigSave" class="btn btn-primary" href="#" role="button">保存配置</a>
                                </div>
                            </div>
                            <div class="col-sm-12">
                                <span class="paramSaveState"></span>
                            </div>
                        </c:if>
                        <c:if test="${task.mode eq 3}">
                            <%-- 单页随机任务 --%>
                            <div class="col-sm-12">
                                <h4>单页随机任务配置</h4>
                                <div class="form">
                                    <div class="form-group">
                                        <label for="inputSinglePagedRand_mtaskSize">一次任务的问题量</label>
                                        <input type="number" class="form-control" id="inputSinglePagedRand_mtaskSize" disabled value="${param_mtask_size}">
                                    </div>
                                    <div class="form-group">
                                        <label for="inputSinglePagedRand_N">N=</label>
                                        <input type="number" class="form-control" id="inputSinglePagedRand_N" disabled value="${param_N}">
                                    </div>
                                    <div class="form-group">
                                        <label for="inputSinglePagedRand_K">K=</label>
                                        <input type="number" class="form-control" id="inputSinglePagedRand_K" disabled value="${param_K}">
                                    </div>
                                    <div class="form-group">
                                        <label for="inputSinglePagedRand_nRows">显示行数</label>
                                        <input type="number" class="form-control" id="inputSinglePagedRand_nRows" disabled value="${param_nRows}">
                                    </div>
                                </div>
                                <p>暂时无法任何参数。勿忘新建一个空的Microtask并保存。</p>
                            </div>
                        </c:if>
                        <c:if test="${task.mode eq 4}">
                            <%--有参考项的创意设计任务--%>
                            <div class="col-sm-12">
                                <h4 class="bg-primary">可含参考项的创意众包任务:配置</h4>
                                <p class="text-primary">当前状态：<span id="pIdeationCurrState">未开始</span></p>
                                <form class="form-horizontal">
                                    <div class="form-group">
                                        <label for="inputIdeationIncrNoRefTask" class="col-sm-2 control-label">新增无参考项任务</label>
                                        <div class="col-sm-2">
                                            <input id="inputIdeationIncrNoRefTask" class="form-control" type="text" placeholder="0">
                                        </div>
                                        <div class="col-sm-8">
                                            <input type="button" class="btn btn-default" id="btnIdeationIncrNonRefTask" value="增加">
                                            无参考任务数量：未领取<span id="pIdeationNoRefTaskCount_notClaimed">${param_noref_allocated_size}</span>
                                            ;已领取<span id="pIdeationNoRefTaskCount_Claimed">${param_noref_claimed_size}</span>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label for="inputIdeationRefSize" class="col-sm-2 control-label">参考项数目</label>
                                        <div class="col-sm-2">
                                            <input type="text" class="form-control" id="inputIdeationRefSize" value="${param_ref_size}">
                                        </div>
                                        <div class="col-sm-8">
                                            <input type="button" class="btn btn-default" id="btnIdeationUpdRefCount" value="更新">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label for="inputIdeationRefColNames" class="col-sm-2 control-label">参考项字段名</label>
                                        <div class="col-sm-5">
                                            <input id="inputIdeationRefColNames" class="form-control" type="text" placeholder="aaa,bbb,ccc" value="${ref_col_names}">
                                        </div>
                                        <div class="col-sm-5">
                                            <input type="button" class="btn btn-default" id="btnIdeationUpdRefColNames" value="更新">
                                        </div>
                                        <div class="col-sm-offset-2 col-sm-10">
                                            <p class="help-block">显示在参与者任务中的参考项字段名，字段名为微任务中写入的各个项目（如输入框）的id号。使用半角逗号分隔。</p>
                                        </div>
                                        </div>
                                    <div class="form-group">
                                        <label for="buttonIdeationDownloadConfFile" class="col-sm-2 control-label">下载任务数据</label>
                                        <div class="col-sm-10">
                                            <a class="btn btn-default" href="<c:url value="/task/taskData/${task.id}"></c:url>" target="_blank" id="buttonIdeationDownloadConfFile">下载</a>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="buttonIdeationUploadConfFile" class="col-sm-2 control-label">上传任务数据</label>
                                        <div class="col-sm-3">
                                            <input type="file" id="buttonIdeationUploadConfFile" class="btn">
                                        </div>
                                        <div class="col-sm-7">
                                            <input type="button" class="btn btn-default" id="buttonIdeationApplyConfig" value="上传">
                                            <span class="text-success">已上传</span>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </c:if>
                    </div>
                </div>
                <!-- workspace -->
                <c:forEach items="${microtasks}" var="microtask">
                    <div role="tabpanel" class="tab-pane" id="${microtask.id}" data-id="${microtask.id}">
                        <div class="row">
                            <div class="col-sm-2">
                                <!-- Microtask control buttons -->
                                <p>
                                    <a id="btnMoveBackward_${microtask.id}" class="btn btn-default btnMoveBackward" role="button"><span class="glyphicon glyphicon-backward"> </span>向前移动</a>
                                </p>
                                <p>
                                    <a id="btnMoveForward_${microtask.id}" class="btn btn-default btnMoveForward" role="button"><span class="glyphicon glyphicon-forward"> </span>向后移动</a>
                                </p>
                                <p>
                                    <a id="btnInsertNext_${microtask.id}" class="btn btn-default btnInsertNext" role="button"><span class="glyphicon glyphicon-plus"> </span>在下一页新建</a>
                                </p>
                                <p>
                                    <a id="btnCopyNext_${microtask.id}" class="btn btn-default btnCopyNext" role="button"><span class="glyphicon glyphicon-expand"> </span>拷贝并新建</a>
                                </p>
                                <p>
                                    <a id="btnSave_${microtask.id}" class="btn btn-primary btnSave" href="#"role="button"><span class="glyphicon glyphicon-floppy-disk"> </span>保存微任务</a>
                                </p>
                                <p>
                                    <a id="btnDelete_${microtask.id}" class="btn btn-danger btnDelete" href="#" role="button"><span class="glyphicon glyphicon-remove"> </span>删除微任务</a>
                                </p>
                                <!-- Insert object buttons -->
                                <p>
                                    <a class="btn btn-default btnInsertImage" href="#" role="button">插入图片</a>
                                </p>
                            </div>
                            <div class="col-sm-10">
                                <form id="${microtask.id}-form">
                                    <input type="hidden" name="id" value="${microtask.id}">

                                    <div class="form-group">
                                        <label id="labelSaveState_${microtask.id}"></label>
                                    </div>
                                    <div class="form-group">
                                        <label>HandlerType</label>
                                        <div class="radio">
                                            <label><input type="radio" name="optionHandlerType_${microtask.id}" value="simple" <c:if test="${microtask.handlerType eq 'simple'}">checked</c:if>>simple</label>
                                        </div>
                                        <div class="radio">
                                            <label><input type="radio" name="optionHandlerType_${microtask.id}" value="simple_ref" <c:if test="${microtask.handlerType eq 'simple_ref'}">checked</c:if>>simple with reference</label>
                                        </div>
                                        <div class="radio">
                                            <label><input type="radio" name="optionHandlerType_${microtask.id}" value="grid_choice" <c:if test="${microtask.handlerType eq 'grid_choice'}">checked</c:if>>相似性判断(网格选择)</label>
                                        </div>

                                        <%--<input type="text" name="handlerType" class="form-control" id="inputHandlerType_${microtask.id}" placeholder="渲染模块类型" value="${microtask.handlerType}">--%>
                                    </div>
                                    <div class="form-group">
                                        <label for="textTemplate_${microtask.id}">Template</label>
                                        <input name="jsonTemplate" type="hidden" class="hiddenJsonTemplate" id="textTemplate_${microtask.id}" data-id="${microtask.id}" value='${microtask.template}'>
                                        <div id="jsonEditor_${microtask.id}" class="inputJsonEditor"></div>
                                    </div>
                                </form>
                            </div>
                        </div>

                    </div>

                </c:forEach>

            </div>
            <!-- panel content template -->
            <div id="panelTemplate" style="display: none;">
                <div class="row">
                    <div class="col-sm-2">
                        <div class="form-group">
                            <p><a id="btnMoveBackward_template" class="btn btn-default btnMoveBackward" role="button"><span class="glyphicon glyphicon-backward"> </span>向前移动</a></p>
                            <p><a id="btnMoveForward_template" class="btn btn-default btnMoveForward" role="button"><span class="glyphicon glyphicon-forward"> </span>向后移动</a></p>
                            <p><a id="btnInsertNext_template" class="btn btn-default btnInsertNext" role="button"><span class="glyphicon glyphicon-plus"> </span>在下一页新建</a></p>
                            <p><a id="btnCopyNext_template" class="btn btn-default btnCopyNext" role="button"><span class="glyphicon glyphicon-expand"> </span>拷贝并新建</a></p>
                            <p><a id="btnSave_template" class="btn btn-primary btnSave" href="#"role="button"><span class="glyphicon glyphicon-floppy-disk"> </span>保存微任务</a></p>
                            <p><a id="btnDelete_template" class="btn btn-danger btnDelete" href="#" role="button"><span class="glyphicon glyphicon-remove"> </span>删除微任务</a></p>
                            <p>
                                <a class="btn btn-default btnInsertImage" href="#" role="button">插入图片</a>
                            </p>
                        </div>
                    </div>
                    <div class="col-sm-10">
                        <div role="tabpanel"class="tab-pane" id="template" data-id="template">
                            <form id="template-form">
                                <input type="hidden" name="id">
                                <div class="form-group">
                                    <label id="labelSaveState_template"></label>
                                </div>
                                <div class="form-group">
                                    <label for="inputHandlerType_template">HandlerType</label>
                                    <div class="radio">
                                        <label><input type="radio" name="optionHandlerType_template" value="simple" checked>simple</label>
                                    </div>
                                    <div class="radio">
                                        <label><input type="radio" name="optionHandlerType_template" value="simple_ref">simple with reference</label>
                                    </div>
                                    <div class="radio">
                                        <label><input type="radio" name="optionHandlerType_template" value="grid_choice">相似性判断(网格选择)</label>
                                    </div>

                                    <label for="inputHandlerType_template">HandlerType</label>
                                    <input type="text" class="form-control" name="handlerType" id="inputHandlerType_template" placeholder="渲染模块类型" value="${(task.mode eq 3)? 'grid_choice' : 'simple'}">

                                </div>
                                <div class="form-group">
                                    <label for="textTemplate_template">Template</label>
                                    <input type="hidden" name="jsonTemplate" class="hiddenJsonTemplate" id="textTemplate_template" data-id="template" value=''>
                                    <div id="jsonEditor_template" class="inputJsonEditor" ></div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    var homeUrl = "<c:url value="/"/>";
    var taskId = ${task.id};
</script>
