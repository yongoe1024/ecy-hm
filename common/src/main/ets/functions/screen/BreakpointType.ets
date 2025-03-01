/**
 * 屏幕断点
 */
/**
 * demo
 *     Text('Test')
 *      .fontSize(  BreakpointType.of('14fp', '16fp', '18fp',this.currentWidthBreakpoint) )
 */
export class BreakpointType {
  static of<T>(sm: T, md: T, lg: T, currentWidthBreakpoint: string) {
    if (currentWidthBreakpoint === 'sm') {
      return sm;
    }
    if (currentWidthBreakpoint === 'md') {
      return md;
    }
    if (currentWidthBreakpoint === 'lg') {
      return lg;
    }
    return sm;
  }
}