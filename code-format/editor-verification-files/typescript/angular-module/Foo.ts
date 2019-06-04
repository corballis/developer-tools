@NgModule({
            declarations: [AppComponent],
            imports: [
              BrowserModule,
              TranslateModule.forRoot(TRANSLATE_MODULE_CONFIG),
              AppRoutingModule,
              OverlayModule,
              CoreModule
            ],
            providers: [
              {
                provide: LOCALE_ID,
                useValue: 'en-GB'
              },
              InitService,
              {
                provide: APP_INITIALIZER,
                useFactory: initFactory,
                deps: [InitService],
                multi: true
              },
              AuthGuard
            ],
            bootstrap: [AppComponent]
          })
export class AppModule {}