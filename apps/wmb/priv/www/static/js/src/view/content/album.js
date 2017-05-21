import React, { PropTypes } from 'react';
// import Button from 'react-toolbox/lib/button/Button';
// import buttonTheme from '../../../../sass/theme/button.scss';

import { Card, CardTitle, CardMedia, Tooltip, Button, CardActions, List, ListItem } from 'react-toolbox';

const AlbumView = ({ handleUnfold, folded, onClick, children, album, artist, cover, date, genre, selected, activeClass }) => {
    // const classNames = classnames('righted', { active: activeClass });

    /* const tooltip = (
        <Tooltip id="tooltip">
            <strong>{ `${artist} - ${album} | `}</strong>
            <span>{ `${date} | ${genre}` }</span>
        </Tooltip>
    );*/

    return (
        <section style={{ flex: '0 350px', padding: '1em 0' }}>
            <Card style={{ width: '350px', background: 'lightgrey' }}>
                <CardTitle
                    avatar   = {encodeURI(cover)}
                    title    = {artist}
                    subtitle = {album}
                />
                <CardMedia
                    aspectRatio = {'square'}
                >
                    <img src={encodeURI(cover)} alt={album} />
                </CardMedia>
                <CardTitle
                    title    = {genre}
                    subtitle = {date}
                />
                <CardActions>
                    {!selected
                        ? (<Button
                            raised
                            primary
                            label="Add album"
                            onClick = {onClick}
                        />)
                        : (<Button raised accent label="Remove album" onClick = {onClick} />)
                    }
                </CardActions>
                <List selectable ripple>
                    <ListItem
                        caption='Tracks'
                        onClick = {handleUnfold}
                        rightIcon={!folded ? 'keyboard_arrow_down' : 'keyboard_arrow_right'}
                        leftIcon={'assignment'}
                    />
                    { children }
                </List>
            </Card>
        </section>
    );
};

AlbumView.propTypes = {
    activeClass: PropTypes.bool,
    album      : PropTypes.string.isRequired,
    artist     : PropTypes.string.isRequired,
    children   : PropTypes.node,
    cover      : PropTypes.string.isRequired,
    date       : PropTypes.string.isRequired,
    genre      : PropTypes.string.isRequired,
    selected   : PropTypes.bool.isRequired,
    onClick    : PropTypes.func.isRequired,
};

export default AlbumView;
