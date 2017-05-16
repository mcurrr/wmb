import React, { PropTypes } from 'react';
// import classnames from 'classnames';
import { ListItem, Avatar } from 'react-toolbox';

const LetterView = ({ onClick, children, letter, artistCount, activeClass }) => {
    // const classNames = classnames({ active: activeClass });
    return (
        <div>
            <ListItem
                rightIcon={activeClass ? 'keyboard_arrow_down' : 'keyboard_arrow_right'}
                onClick = {onClick}
            >
                <div style = {{ textAlign: 'center' }} >
                    <Avatar
                        style = {{ backgroundColor: activeClass ? 'deeppink' : 'deepskyblue' }}
                        title = {letter}
                    />
                </div>
            </ListItem>
            <div>
                { children }
            </div>
        </div>
    );
};

LetterView.propTypes = {
    activeClass: PropTypes.bool,
    artistCount: PropTypes.number,
    children   : PropTypes.node,
    letter     : PropTypes.string.isRequired,
    onClick    : PropTypes.func.isRequired,
};

export default LetterView;
