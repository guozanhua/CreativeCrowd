<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: inlab-dell
  Date: 2016/6/13
  Time: 10:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="container">
    <h4>${task.title}:任务配置</h4>
    <div class="row" style="margin-top: 0.5rem;">
        <div class="col-sm-12">
            <!-- nav tabs-->
            <ul class="nav nav-tabs" role="tablist">
                <!-- Control Panel -->
                <li id="control-li" role="presentation" class="active" data-id="control">
                    <a href="#control" aria-controls="control" role="tab" data-toggle="tab">设置</a>
                </li>
                <!-- Existing microtasks -->
                <c:forEach items="${microtasks}" var="microtask">
                    <li role="presentation" id="${microtask.id}-li">
                        <a href="#${microtask.id}" aria-controls="${microtask.id}" role="tab" data-toggle="tab">#${microtask.id}</a>
                    </li>
                </c:forEach>
                <!-- `Add` button -->
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
                        <c:if test="${task.mode eq 2}">
                            <div class="col-sm-12">
                                <h4>顺序任务配置</h4>
                                <a id="btnSeqConfigSave" class="btn btn-primary" href="#" role="button">保存微任务顺序</a>
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
                                    <input class="form-control " id="inputTaskParams" value="${task.params}">
                                </div>
                                <div class="col-sm-6">
                                    <a id="btnRandConfigSave" class="btn btn-primary" href="#" role="button">保存配置</a>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
                <!-- workspace -->
                <c:forEach items="${microtasks}" var="microtask">
                    <div role="tabpanel" class="tab-pane" id="${microtask.id}" data-id="${microtask.id}">
                        <form id="${microtask.id}-form">
                            <input type="hidden" name="id" value="${microtask.id}">
                            <div class="form-group">
                                <a id="btnMoveBackward_${microtask.id}" class="btn btn-default btnMoveBackward" role="button"><span class="glyphicon glyphicon-backward"> </span>向前移动</a>
                                <a id="btnMoveForward_${microtask.id}" class="btn btn-default btnMoveForward" role="button"><span class="glyphicon glyphicon-forward"> </span>向后移动</a>
                                <a id="btnInsertNext_${microtask.id}" class="btn btn-default btnInsertNext" role="button"><span class="glyphicon glyphicon-plus"> </span>在下一页新建</a>
                                <a id="btnSave_${microtask.id}" class="btn btn-primary btnSave" href="#"role="button"><span class="glyphicon glyphicon-floppy-disk"> </span>保存微任务</a>
                                <a id="btnDelete_${microtask.id}" class="btn btn-danger btnDelete" href="#" role="button"><span class="glyphicon glyphicon-remove"> </span>删除微任务</a>
                            </div>
                            <div class="form-group">
                                <label id="labelSaveState_${microtask.id}"></label>
                            </div>
                            <div class="form-group">
                                <label for="inputHandlerType_${microtask.id}">HandlerType</label>
                                <input type="text" name="handlerType" class="form-control" id="inputHandlerType_${microtask.id}" placeholder="渲染模块类型" value="${microtask.handlerType}">
                            </div>
                            <div class="form-group">
                                <label for="textTemplate_${microtask.id}">Template</label>
                                <input name="jsonTemplate" type="hidden" class="hiddenJsonTemplate" id="textTemplate_${microtask.id}" data-id="${microtask.id}" value='${microtask.template}'>
                                <div id="jsonEditor_${microtask.id}" class="inputJsonEditor"></div>
                            </div>
                        </form>
                    </div>

                </c:forEach>

            </div>
            <!-- panel content template -->
            <div id="panelTemplate" style="display: none;">

                <div role="tabpanel"class="tab-pane" id="template" data-id="template">
                    <form id="template-form">
                        <input type="hidden" name="id">
                        <div class="form-group">
                            <a id="btnMoveBackward_template" class="btn btn-default btnMoveBackward" role="button"><span class="glyphicon glyphicon-backward"> </span>向前移动</a>
                            <a id="btnMoveForward_template" class="btn btn-default btnMoveForward" role="button"><span class="glyphicon glyphicon-forward"> </span>向后移动</a>
                            <a id="btnInsertNext_template" class="btn btn-default btnInsertNext" role="button"><span class="glyphicon glyphicon-plus"> </span>在下一页新建</a>
                            <a id="btnSave_template" class="btn btn-primary btnSave" href="#"role="button"><span class="glyphicon glyphicon-floppy-disk"> </span>保存微任务</a>
                            <a id="btnDelete_template" class="btn btn-danger btnDelete" href="#" role="button"><span class="glyphicon glyphicon-remove"> </span>删除微任务</a>
                        </div>
                        <div class="form-group">
                            <label id="labelSaveState_template"></label>
                        </div>
                        <div class="form-group">
                            <label for="inputHandlerType_template">HandlerType</label>
                            <input type="text" class="form-control" name="handlerType" id="inputHandlerType_template" placeholder="渲染模块类型" value="simple">
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

<script>
    var homeUrl = "<c:url value="/"/>";
    var taskId = ${task.id};
</script>
