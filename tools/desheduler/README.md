主要问题
    Kubernetes的调度是将挂起的pod绑定到节点的过程，由kube-scheduler的一个组件执行。调度器的决策，无论一个pod可以或不能被调度，都是由它的可配置策略指导的，该策略由一系列规则组成，称为谓词和优先级。调度器的决策受其对Kubernetes集群的观点的影响，此时一个新的pod将首次出现调度。由于Kubernetes集群非常动态，而且随着时间的推移，它们的状态会发生变化，因此可能需要将已经运行的pod迁移到其他节点，主要的问题点:
    1.一些节点处于或过度使用。
    2.原来的调度决策不再具有实际意义，因为在节点上添加或删除了标记或标签，pod/节点关联需求不再满足。
    3.一些节点失败，它们的pod移动到其他节点。
    

解决方案
    为了解决以上问题，引入了descheduler,Descheduler可以在一个pod中运行。它的优点是能够在不需要用户干预的情况下运行多次。Descheduler pod作为一个关键的pod运行，以避免被自己或kubelet驱逐。由于在kube系统名称空间中创建了关键的pod，所以在kube-system名称空间中也将创建descheduler job及其pod.Descheduler解决上述不同的问题依靠的就是它不一样的策略，Descheduler的策略是可配置的，包括启用或禁用策略。四种策略，远程复制，低利用率，RemovePodsViolatingInterPodAntiAffinity, RemovePodsViolatingNodeAffinity当前实现。作为策略的一部分，可以配置与策略相关的参数。默认情况下，所有策略都是启用的。以下为其所拥有的几个策略。
      
     1.RemoveDuplicates
       该策略确保只有一个pod与一个副本集(RS)、复制控制器(RC)、部署或在同一节点上运行的作业相关联。如果有更多，这些重复的pods会被驱逐，以便更好地在集群中传播pods。这个问题可能会发生，如果某些节点由于某种原因而宕机，它们的pod被转移到其他节点上，从而导致与RS或RC相关的多个pod，例如，在同一个节点上运行。一旦失败的节点再次准备就绪，这个策略就可以被激活来驱逐那些重复的pod。目前，没有与此策略相关的参数。
    
     2.LowNodeUtilization
      这一策略就是通过设置阈值将pods均匀的分布到所有节点上。该策略的参数配置在noderesource利用率阈值下，节点的利用率由可配置的阈值、阈值决定。阈值阈值可以配置为cpu、内存和pod的百分比。如果一个节点的使用率低于所有(cpu、内存和pods的数量)的阈值，那么该节点就被认为没有充分利用。目前，计算节点资源的利用率考虑了pod的请求资源需求。还有另一个可配置的阈值，targetthreshold，用于计算那些可能被逐出的pod的潜在节点。在阈值、阈值和target阈值之间的任何节点都被认为是被适当利用的，并且不考虑被驱逐。阈值，targetthreshold，可以配置为cpu、内存和数量的pod。

    3.RemovePodsViolatingInterPodAntiAffinity
     这一策略确保了违反跨pod反亲和力的pod从节点中删除。例如，如果在节点上有podA, podB和podC(在相同的节点上运行)有反关联规则，这些规则禁止它们在同一个节点上运行，那么podA就会从节点中被逐出，这样podB和podC就可以运行了。这个问题可能会发生，当B类的反关联规则被创建时，它们已经在节点上运行了。目前，没有与此策略相关的参数。


    4.RemovePodsViolatingInterPodAntiAffinity
     这个策略确保了违反节点关联的pod从节点中删除。例如,有podA原定在nodeA满足节点关联规则时requiredDuringSchedulingIgnoredDuringExecution调度,但随着时间的推移nodeA不再满足规则,如果另一个节点nodeB可以满足节点关联规则,然后从nodeA podA将驱逐。

使用步骤
kubectl apply -Rf .
     
