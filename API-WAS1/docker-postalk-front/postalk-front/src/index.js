import 'react-app-polyfill/ie11';
import 'react-app-polyfill/stable';
import React, { Suspense } from 'react'
import ReactDOM from 'react-dom'
import { ThemeProvider } from '@material-ui/core/styles'
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom'
import * as serviceWorker from './serviceWorker'

import './style/index.scss'

import Loading from './components/loading/Loading'
import { realRoutes } from './configs/routes'
import theme from './style/theme'

if (!window.localStorage.getItem('token') && window.location.pathname !== '/login') {
  // window.location.href = '/login'
}

ReactDOM.render(
  <ThemeProvider theme={theme}>
    <Router>
      <Suspense fallback={<Loading />}>
        <Switch>
          {realRoutes.map((route, i) => route.path && (
            <Route key={i} exact path={route.path} component={route.component} />
          ))}
        </Switch>
      </Suspense>
    </Router>
  </ThemeProvider>
, document.getElementById('root'))

serviceWorker.unregister()
