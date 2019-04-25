import React from 'react'
import { Route, HashRouter, Switch } from 'react-router-dom'
import Main from './screens/main'
import ScrollToTop from './screens/scrollToTop'

export default props => (
  <HashRouter>
    <ScrollToTop>
      <Switch>
        <Route exact path='/' component={Main} />
      </Switch>
    </ScrollToTop>
  </HashRouter>
)
