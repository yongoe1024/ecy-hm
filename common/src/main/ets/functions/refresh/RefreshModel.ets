/**
 * 分页刷新数据模型
 */
export type FetchDataBlock = (pageState: RefreshPageState, isRefresh: boolean) => Promise<PageModel>

export type ItemBuilderBlock = (item: ESObject, index: number) => void

export class RefreshPageState {
  current: number = 1
  size: number = 10
  isError: boolean = false
  isLoading: boolean = false
  isEmpty: boolean = false
  // 初始化必须有
  hasMore: boolean = true
  // 白屏页提示语
  errorMessage: string = '请求失败'
  // 白屏错误页code码
  errorCode: number = 500

  constructor(current: number, size: number) {
    this.current = current
    this.size = size
  }
}

export class PageModel {
  /**
   * 总记录数
   */
  total: number
  /**
   * 每页记录数
   */
  size: number
  /**
   * 当前页数
   */
  current: number
  /**
   * 总页数
   */
  pages: number
  /**
   * 列表数据
   */
  list: ESObject[]

  constructor(total: string | number, size: string | number, current: string | number, pages: string | number,
    list: ESObject[]) {
    this.total = Number(total)
    this.size = Number(size)
    this.current = Number(current)
    this.pages = Number(pages)
    this.list = list
  }
}