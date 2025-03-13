import { ListView, RefreshController, RefreshLayout, RefreshPositionEnum } from '@abner/refresh'
import { PageModel, RefreshListView, RefreshPageReactor, RefreshPageState } from 'common'
import { BusinessError } from '@kit.BasicServicesKit'

/**
 * AUTHOR:AbnerMing
 * DATE:2024/6/20
 * INTRODUCE:任意组件之，使用RefreshLayout做吸顶组件
 * */
@Entry
@Component
export struct DemoXX {
  refreshPageReactor: RefreshPageReactor = new RefreshPageReactor()

  async get(pageState: RefreshPageState): Promise<PageModel> {
    return new Promise(async (resolve, reject) => {
      try {
        let a: string[] = []
        for (let i = 0; i < 20; i++) {
          a.push(i + '')
        }
        // reject({ code:500, message: ''} as BusinessError)
        // 错误返回，此处code是返回的 code ，message没啥用
        // reject({ code: 500, message: '请求错误' } as BusinessError)
        // 正确返回，返回 BasePagingModel，后端缺字段无法对应，会导致错误
       setTimeout(()=>{
         resolve(new PageModel(11111, 20, pageState.current, 11111, a))
       },1000)
      } catch (e) {
        // todo 此处异常看看axios
        reject({ code: e.code, message: e.message } as BusinessError)
      }
    })
  }

  @Builder
  itemBuilder(item: ESObject, index: number) {
    Text("测试数据" + index)
      .width("95%")
      .height(50)
      .margin(10)
      .textAlign(TextAlign.Center)
      .border({ width: 1, color: Color.Pink })
  }

  build() {
    Column() {
      // 普通list
      RefreshListView({
        reactor: this.refreshPageReactor,
        itemBuilder: this.itemBuilder,
        fetchDataBlock: (pageState: RefreshPageState, isRefresh: boolean) => {
          return this.get(pageState)
        }
      }).onAppear(() => {
        this.refreshPageReactor.fetchData(true)
      })
    }

  }
}
