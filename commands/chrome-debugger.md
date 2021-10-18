# Chrome debugger

## AngularJS
https://blog.ionicframework.com/angularjs-console/

*Not - interaction w. screen updates it*

```javascript
angular.element($('dis-screenings-table')).isolateScope().$ctrl // Get the component

angular.element($1).isolateScope().$ctrl.screenings = [] // Set a component value to something

angular.element($('dis-screenings-table')).isolateScope().$apply() // Force angular to rerun bindings

angular.element(document.body).injector().get('MyService')// Get some service
```

## Angular
https://juristr.com/blog/2016/02/debugging-angular2-console/ <-- OLD
https://juristr.com/blog/2019/09/debugging-angular-ivy-console/ <-- NEW
https://mobiarch.wordpress.com/2020/07/08/ng-probe-no-more/

```javascript
// ng.getComponent = Ivy
// ng.probe = not ivy
// Right click an element and store it as a Global variable. Will be called temp1, temp2 etc.
ng.getComponent($0) //Get component - select component via devtools first
let component = ng.getComponent($0); // Store component
component.componentInstance
ng.getOwningComponent()
ng.applyChanges(matDrawer); // Run component CD
component._debugInfo._view.changeDetectorRef.detectChanges() // Run component CD v2.
component.injector.get(ng.coreTokens.ApplicationRef) // Run global CD
```

## JQuery
var script = document.createElement('script');
script.type = 'text/javascript';
script.src = 'https://code.jquery.com/jquery-3.6.0.min.js';
document.head.appendChild(script);