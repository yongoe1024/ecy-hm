class WebEventSDK {
    ports
    onMessage
    onArrayBufferMessage
    onReady

    constructor(webEventInitParam) {
        this.onMessage = webEventInitParam.onMessage
        this.onArrayBufferMessage = webEventInitParam.onArrayBufferMessage
        this.onReady = webEventInitParam.onReady
    }

    init() {
        // 给窗体添加一个message事件监听
        window.addEventListener('message', event => {
            if (event.data == '__init_port__') {
                this.ports = event.ports[0] //接收鸿蒙端分配的端口
                this.ports.onmessage = event => {
                    var result = event.data
                    if (typeof result === 'string' && this.onMessage) {
                        const data = JSON.parse(result)
                        this.onMessage(data.type, data.data)
                    } else if (typeof result === 'object' && result instanceof ArrayBuffer && onArrayBufferMessage) {
                        this.onArrayBufferMessage(result)
                    }
                }
                if (this.onReady) {
                    this.onReady()
                }
            }
        })
    }

    // 使用h5Port向应用侧发送消息。
    postMessage(type, data) {
        let msg = {
            type: type,
            data: data
        }
        this.ports.postMessage(JSON.stringify(msg))
    }

    postArrayBufferMessage(arrayBuffer) {
        this.ports.postMessage(arrayBuffer)
    }
}

/**
 const webEventSDK = new WebEventSDK({
 onReady: () => {
 webEventSDK.postMessage('log', '我要打印日志')
 },
 onMessage: (type, data) => {
 if (type === 'beginDriving') {
 beginDriving(data.start, data.end)
 }
 }
 })
 webEventSDK.init()
 */
