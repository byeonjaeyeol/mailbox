import { createMuiTheme } from '@material-ui/core/styles'
import * as colors from '@material-ui/core/colors'

const theme = createMuiTheme({
  palette: {
    primary: {
      main: '#ff554a',
    },
    secondary: {
      main: colors.orange[500],
    },
    error: {
      main: colors.red.A400,
    },
    background: {
      default: '#fff',
    },
  },

  typography: {
    fontFamily: ['"Noto Sans KR", sans-serif']
  }
})

export default theme