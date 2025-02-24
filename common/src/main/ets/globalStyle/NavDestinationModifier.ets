/**
 * NavDestination 公用样式
 */
export class NavDesModifier implements AttributeModifier<NavDestinationAttribute> {
  applyNormalAttribute(instance: NavDestinationAttribute): void {
    instance.width('100%')
    instance.hideTitleBar(true)
    instance.height('100%')
  }
}