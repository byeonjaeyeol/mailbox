import React from 'react'
import { NavLink } from 'react-router-dom'
import { List, ListItem, ListItemText, Divider, Icon, Collapse } from '@material-ui/core'
import { match as createMatch } from 'path-to-regexp2'

import routes from '../../configs/routes'
import logo from '../../images/logo.png'

import './nav.scss'

const isSystem = window.localStorage.getItem('type') === 'system'
//kimcy add
const isUserAdmin = window.localStorage.getItem('authority') === 'admin'


const Link = ({ path, children, parent, isActive, i, toggleOpen, init, setInit }) => {
  const className = parent ? 'parent' : 'children'

  const handleIsActive = (match, location) => {
    const result = isActive ? !!createMatch(isActive)(location.pathname) : !!match

    if (!init && result) {
      toggleOpen(i)
      setInit(true)
    }

    return result
  }

  return path === undefined ? (
    <div className={className}>
      {children}
    </div>
  ) : (
    <NavLink exact to={path} className={className} isActive={handleIsActive}>
      {children}
    </NavLink>
  )
}

const LinkListItem = ({ i, path, label, hidden, parent, isActive, toggleOpen, ...props }) => {
  return !hidden && (
    <Link path={path} parent={parent} isActive={isActive} i={i} toggleOpen={toggleOpen} {...props}>
      <ListItem button dense onClick={() => parent && !path && toggleOpen(i)}>
        <ListItemText primary={label} />
      </ListItem>
    </Link>
  )
}

const Nav = () => {
  const [init, setInit] = React.useState(false)
  const [open, setOpen] = React.useState(null)

  const toggleOpen = (i) => {
    setOpen(init && open === i ? null : i)
  }

  React.useEffect(() => {
    setInit(false)
  }, [window.location.pathname])


  return (
    <nav className="nav">
      <div className="logo">
        <img src={logo} alt="logo" />
      </div>

      <List>
        {routes.map((item, i) => !item.hidden && (!item.system || (item.system && isSystem) || (item.admin && isUserAdmin)) && (
          <div className="group" key={i}>
            <LinkListItem init={init} setInit={setInit} {...item} parent toggleOpen={toggleOpen} i={i} />

            {Boolean(item.children?.length) && (
              <>
                <Collapse in={open === i} timeout="auto">
                  {item.children.map((item2, i2) => (!item2.system || (item2.system && isSystem) || (item2.admin && isUserAdmin)) && (
                    <LinkListItem init={init} setInit={setInit} {...item2} key={i2} toggleOpen={toggleOpen} i={i} />
                  ))}
                </Collapse>

                <Icon className="expandIcon">{open && open === i ? 'expand_less' : 'expand_more'}</Icon>
              </>
            )}

            <Divider />
          </div>
        ))}
      </List>
    </nav>
  )
}

export default Nav