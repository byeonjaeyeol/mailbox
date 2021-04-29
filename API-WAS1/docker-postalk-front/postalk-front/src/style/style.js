import { makeStyles } from '@material-ui/core/styles'

const useStyles = makeStyles(theme => ({
  root: {
    padding: theme.spacing(3, 2)
  },

  statusBox: {
    display: 'flex',
    alignItems: 'center',
    flexDirection: 'column',
    color: '#fff',
    padding: theme.spacing(3, 2),
  }
}))

export default useStyles