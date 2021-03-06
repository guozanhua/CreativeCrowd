<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
    N选k 图片+文字描述的设计方案相似度判断
 * Parse similarity judging microtask page which is a "choose K objects from N candidates" question.
 * Each object consists one text description and one image, all items and parameters are passed in as a JSON list string written as:
 * [
 *  {"N":N }, {"K":K},
 *  {"nRows": num_of_rows},  // #columns = N / num_of_rows
 *  {"ref_item": {"image":internal_url, "text":text_description}},
 *  //following N elements
 *  {"item": {"image":internal_url, "text":text_description} },
 *  ...
 * ]
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<script src="https://unpkg.com/vue/dist/vue.js"></script>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-1">
            <p role="alert" id="alert-progress" class="text-center"><small>Progress:{{progress}}</small></p>
        </div>

        <div class="col-md-10">
            <div class="alert alert-info" role="alert" id="metainfo">Select <kbd><span v-if="freeChoice">at least</span> {{K}}</kbd> design solutions from the candidates on the right, which is more similar than other candidates to the reference solution shown left. Click an image to zoom up.</div>
        </div>

        <div class="col-md-1">
            <button type="button" v-on:click="clickFunc" class="btn btn-success" id="btn-next" v-bind:disabled="next_btn_disabled">${(empty next)? 'Finish':'Next'}</button>
        </div>
    </div>
    <div class="row">

        <div class="col-md-2">
            <!--Reference item-->
            <div class="panel panel-primary">
                <div class="panel-heading">
                    Reference
                </div>
                <div class="panel-body">
                    <div class="col-md-12" id="div-ref">
                        <div class="row">
                            <a v-bind:href="image" class="single-popup-link">
                                <img v-bind:src="image" class="img-responsive center-block" title="Click to see detail">
                            </a>
                        </div>
                        <div class="row">
                            <p id="ref-image-title" class="">
                                {{text}}
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-10" id="div-candidate">
            <!--Candidate item-->
            <%--<div class="row" id="div-candidate">--%>

                <template v-for="(item, index) in items">
                    <div class="col-md-6">
                        <div class="row">
                            <div class="col-md-3">
                                <!-- img -->
                                <a v-bind:href="item.image" class="group-popup-link">
                                    <img v-bind:src="item.image" class="img-responsive center-block img-rounded" title="Click to see detail">
                                </a>
                                <div class="text-center">
                                    <button type="button" v-on:click="selectToggle(item.id, index, $event)" class="btn cand-select" :class="item.selected ? 'btn-danger' : 'btn-primary'">
                                        <span v-if="item.selected">De-</span>Select
                                    </button>
                                </div>
                            </div>
                            <div class="col-md-9 text-min-ht">
                                <!-- text -->
                                <div class="row" v-show="item.selected && fbs_on">
                                    <p class="bg-danger"> In which aspect(s) is this candidate similar to the reference?<br>
                                        <label class="checkbox-inline">
                                            <input type="checkbox" value="f" v-model="item.fbs_checked">Function
                                        </label>
                                        <label class="checkbox-inline">
                                            <input type="checkbox" value="b" v-model="item.fbs_checked">Behaviour
                                        </label>
                                        <label class="checkbox-inline">
                                            <input type="checkbox" value="s" v-model="item.fbs_checked">Structure
                                        </label>
                                        &nbsp;
                                        <span class="glyphicon glyphicon-question-sign fbs_tooltip" ></span>
                                    </p>
                                </div>
                                <div class="row">
                                    <p class="cand-img-titles pre-scrollable">
                                        {{ item.text }}
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>

                </template>

            <%--</div>--%>
        </div>
    </div>

</div>

<script type="text/javascript">

    var candidate_items = [];
<c:forEach items="${handlerContent}" var="model">
    <%-- instance of JstlCompatibleModel --%>
    <c:choose>
        <c:when test="${model.tag eq 'params'}">
            var grid_params = {
                N:${model.contents['N']},
                K:${model.contents['K']},
                nRows:${model.contents['nRows']},
                progress:"${model.contents['progress']}",
                freeChoice: ${model.contents['freeChoice']}
            };
        </c:when>
        <c:when test="${model.tag eq 'ref_item'}">
            var ref_item = {
                id: '${model.contents['image']}',
                image: '<c:url value="/"/>/static/img/upload/task/${task.id}/${model.contents['image']}.jpg',
                text : '${model.contents['text']}'
            };
        </c:when>
        <c:when test="${model.tag eq 'item'}">
            candidate_items.push({
                id: '${model.contents['image']}',
                image: '<c:url value="/"/>/static/img/upload/task/${task.id}/${model.contents['image']}.jpg',
                text : '${model.contents['text']}',
                selected: false,
                fbs_checked: []
            });
        </c:when>
    </c:choose>
</c:forEach>

</script>